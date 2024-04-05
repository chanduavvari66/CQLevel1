@isTest
private class SyncPartObjectTest {

    @isTest
    static void testSyncParts() {
        // Create test data for mock HTTP response
        String mockResponse = '[{"PartName": "Test Part 1", "x_id": "12345", "TotalQuantityShipped": "50"}, ' +
                              '{"PartName": "Test Part 2", "x_id": "67890", "TotalQuantityShipped": "100"}]';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));

        // Test syncParts method
        Test.startTest();
        SyncPartObject.syncPartRecords();
        Test.stopTest();

        // Verify the insertion of SQX_Part__c records
        List<SQX_Part__c> insertedParts = [SELECT Name, Part_Number__c, Active__c, Related_Account__c FROM SQX_Part__c];
        System.assertEquals(2, insertedParts.size(), 'Incorrect number of parts inserted');

        // Verify the values of inserted parts
        for (SQX_Part__c part : insertedParts) {
            if (part.Part_Number__c == '12345') {
                System.assertEquals('Test Part 1', part.Name, 'Incorrect part name for Test Part 1');
                System.assertEquals(true, part.Active__c, 'Incorrect Active status for Test Part 1');
                // Add more assertions if needed
            } else if (part.Part_Number__c == '67890') {
                System.assertEquals('Test Part 2', part.Name, 'Incorrect part name for Test Part 2');
                System.assertEquals(true, part.Active__c, 'Incorrect Active status for Test Part 2');
                // Add more assertions if needed
            }
        }
    }

    // Mock HTTP response generator class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String response;
        private Integer statusCode;

        MockHttpResponseGenerator(String response, Integer statusCode) {
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