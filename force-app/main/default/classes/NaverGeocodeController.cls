public with sharing class NaverGeocodeController {
    private static final String CLIENT_ID = 'etptv7f9j1';
    private static final String CLIENT_SECRET = 'M6x9MJv3HdqcIi1SAcxgqsJOgZKSU2kEtp89pxOw';
    private static final String BASE_URL = 'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode';

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCoordinates(String address) {
        Map<String, String> responseMap = new Map<String, String>();
        
        try {
            String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');
            String requestUrl = BASE_URL + '?query=' + encodedAddress;

            HttpRequest request = new HttpRequest();
            request.setEndpoint(requestUrl);
            request.setMethod('GET');
            request.setHeader('X-NCP-APIGW-API-KEY-ID', CLIENT_ID);
            request.setHeader('X-NCP-APIGW-API-KEY', CLIENT_SECRET);
            request.setTimeout(5000);

            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> addresses = (List<Object>) jsonResponse.get('addresses');

                if (!addresses.isEmpty()) {
                    Map<String, Object> addressData = (Map<String, Object>) addresses[0];
                    responseMap.put('lat', String.valueOf(addressData.get('y')));
                    responseMap.put('lng', String.valueOf(addressData.get('x')));
                }
            }
        } catch (Exception e) {
            System.debug('Error calling Naver API: ' + e.getMessage());
        }

        return responseMap;
    }
}