@isTest
private class PartSyncObjectTest {

    @isTest
    static void partsTestMethod() {
        // Creating test data HTTP response
        String testResponse = '[{"PartName": "Part 1", "x_id": "11111", "TotalQuantityShipped": "99"}, ' +
                              '{"PartName": "Part 2", "x_id": "22222", "TotalQuantityShipped": "101"}]';

        Test.setMock(HttpCalloutMock.class, new MockHttp(testResponse, 200));
        
        // Insert Account High and Low Volume
        Account highVolume = new Account(Name='High Volume');
        insert highVolume;
        Account lowVolume = new Account(Name='Low Volume');
		insert lowVolume;
        
        // Starting Test
        Test.startTest();
        PartSyncObject.syncPart_Api();
        Test.stopTest();

        //Getting SQX_Part__c records
        List<SQX_Part__c> partsInserted = [SELECT Name, Part_Number__c, Active__c, Related_Account__c FROM SQX_Part__c];
        System.assertEquals(2, partsInserted.size(), 'Parts not inserted');

        // Verifying the values of inserted parts
        for (SQX_Part__c part : partsInserted) {
            if (part.Part_Number__c == '11111') {
                System.assertEquals('Part 1', part.Name, 'Part 1 not inserted');
                System.assertEquals(true, part.Active__c, 'Active is false for part 1');
                System.assertEquals(highVolume.Id, part.Related_Account__c, 'Incorrect Related Account Part 1');
            } else if (part.Part_Number__c == '22222') {
                System.assertEquals('Part 2', part.Name, 'part 2 not inserted');
                System.assertEquals(true, part.Active__c, 'Active is false for part 2');
                System.assertEquals(lowVolume.Id, part.Related_Account__c, 'Incorrect Related Account Part 2');
            }
        }
    }

    // Mock HTTP response generator class
    private class MockHttp implements HttpCalloutMock {
        private String response;
        private Integer statusCode;

        MockHttp(String response, Integer statusCode) {
            this.response = response;
            this.statusCode = statusCode;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(statusCode);
            return res;
        }
    }
}
