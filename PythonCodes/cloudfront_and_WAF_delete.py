import boto3
import time

def delete_cloudfront_distribution(distribution_id):
    client = boto3.client('cloudfront')
    
    # First, we need to disable the distribution before we can delete it
    print(f"Disabling distribution {distribution_id}...")
    
    # Get the current distribution config
    response = client.get_distribution_config(Id=distribution_id)
    etag = response['ETag']
    config = response['DistributionConfig']
    
    # Disable the distribution
    config['Enabled'] = False
    client.update_distribution(
        Id=distribution_id,
        DistributionConfig=config,
        IfMatch=etag
    )
    
    # Wait for the distribution to be deployed after disabling
    wait_for_distribution_deployed(distribution_id)
    
    # Now we can delete the distribution
    print(f"Deleting distribution {distribution_id}...")
    response = client.get_distribution(Id=distribution_id)
    client.delete_distribution(
        Id=distribution_id,
        IfMatch=response['ETag']
    )
    print("Distribution deleted successfully")

def delete_waf_web_acl(web_acl_name):
    waf = boto3.client('wafv2', region_name='us-east-1')
    
    try:
        # First, get the Web ACL ID
        response = waf.list_web_acls(Scope='CLOUDFRONT')
        web_acl_id = None
        
        for acl in response['WebACLs']:
            if acl['Name'] == web_acl_name:
                web_acl_id = acl['Id']
                break
        
        if web_acl_id:
            print(f"Deleting WAF Web ACL: {web_acl_name}")
            waf.delete_web_acl(
                Name=web_acl_name,
                Scope='CLOUDFRONT',
                Id=web_acl_id,
                LockToken=acl['LockToken']
            )
            print("WAF Web ACL deleted successfully")
        else:
            print(f"WAF Web ACL '{web_acl_name}' not found")
            
    except Exception as e:
        print(f"Error deleting WAF Web ACL: {str(e)}")
        raise

def wait_for_distribution_deployed(distribution_id):
    client = boto3.client('cloudfront')
    print(f"Waiting for distribution {distribution_id} to be deployed...")
    
    while True:
        response = client.get_distribution(Id=distribution_id)
        status = response['Distribution']['Status']
        
        if status == 'Deployed':
            print("Distribution is now deployed!")
            break
        
        print(f"Current status: {status}. Waiting 30 seconds...")
        time.sleep(30)

if __name__ == "__main__":
    try:
        # You'll need to provide the distribution ID
        distribution_id = input("Enter the CloudFront distribution ID to delete: ")
        
        # Delete the CloudFront distribution first
        delete_cloudfront_distribution(distribution_id)
        
        # Then delete the WAF Web ACL
        delete_waf_web_acl('CloudFront-Protection')
        
    except Exception as e:
        print(f"An error occurred: {str(e)}")