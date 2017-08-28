/******************************************************************************
 * Controller for the LPDCR_Community_Homepage
 * @Author: Shruti Mishra
 * @Date: June 06, 2017 
 * @Jira: 
 */
 
public without sharing class LPDCR_Community_HomeCntrlr{
    
    public LPDCR_Community_HomeCntrlr(){
        
    }
    
    public PageReference navigateToCommunity(){
        
        PageReference ref;
        String l_dealer_community_sso_link;
        /*List<NetworkMember> myCommunity = [ SELECT NetworkId, Network.UrlPathPrefix 
                                            FROM NetworkMember
                                            WHERE MemberId = :UserInfo.getUserId() 
                                             AND Network.Name = :Label.LPDCR_CommunityName
                                            LIMIT 1 ];
        if( myCommunity.size() == 0 )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have access to the community ' + Label.LPDCR_CommunityName + '. Please contact your System Administrator for access.' );
            ApexPages.addMessage( l_msg );
            return null;
        }*/
        
        LOLMyLinksCallouts my_links_callout = new LOLMyLinksCallouts();
        
        if(my_links_callout.GetSpecificMyLink(Label.LPDCR_Dealer_Community_AppCode) != null){
            l_dealer_community_sso_link = my_links_callout.GetSpecificMyLink(Label.LPDCR_Dealer_Community_AppCode).myAppUrl;
        }
        
        //ref = new PageReference( Label.LPDCR_Community_BaseURL);
        
        if( l_dealer_community_sso_link != null ){
            ref = new PageReference( l_dealer_community_sso_link );            
        }
        else
        {
            //ref = new PageReference('https://dlrcommqa-landolakespartners.cs2.force.com/mypurinamills/');
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have SSO access to the community ' + Label.LPDCR_CommunityName + '. Please contact your System Administrator for access.' );
            ApexPages.addMessage( l_msg );
            return null;
        }
        
        /*
        System.debug('myCommunity---->'+myCommunity[0].NetworkId);
        String l_path_prefix = '%' + myCommunity[ 0 ].Network.UrlPathPrefix + '%';
        
        Domain l_domain = [ SELECT Id, Domain
                            FROM Domain
                            WHERE Id IN ( SELECT DomainId
                                          FROM DomainSite 
                                          WHERE PathPrefix LIKE :l_path_prefix )
                            LIMIT 1 ];
        System.debug('l_domain---->'+l_domain);
        PageReference ref = new PageReference( 'https://' 
                                                + l_domain.Domain 
                                                + '/' 
                                                + myCommunity[ 0 ].Network.UrlPathPrefix
                                                + '/'
                                                + 'LPDCR_CC_Homepage' );
                                                //.../servlet/networks/switch?networkId=0DBR0000000CaYI  NetworkId
        //PageReference ref = new PageReference('/servlet/networks/switch?networkId='+myCommunity[0].NetworkId);        
        */
        
        System.debug('ref---->'+ref);
        ref.setRedirect( true ); 
        return ref;
    }
}