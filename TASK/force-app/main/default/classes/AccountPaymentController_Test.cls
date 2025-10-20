/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class AccountPaymentController_Test {

    // Test verilerini oluşturma
    @TestSetup
    static void setup() {
        // Test Account oluşturma
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Test Payment oluşturma
        Payment__c pay = new Payment__c(
            Payment_Type__c = 'Service',
            Amount__c = 100,
            Due_Date__c = Date.today().addDays(10),
            Notes__c = 'Test Payment',
            Account__c = acc.Id
        );
        insert pay;

        // Boş account (Payment olmayan)
        Account emptyAcc = new Account(Name = 'Empty Account');
        insert emptyAcc;
    }

    // getAccounts() testi
    @IsTest
    static void testGetAccounts() {
        List<Account> accounts = AccountPaymentController.getAccounts();
        System.assert(accounts.size() >= 2, 'Accounts should be returned (Test Account + Empty Account)');
    }

    // getPaymentsByAccountId() testi
    @IsTest
    static void testGetPaymentsByAccountId_WithPayments() {
        Account acc = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
        List<Payment__c> payments = AccountPaymentController.getPaymentsByAccountId(acc.Id);
        System.assert(payments.size() == 1, 'Payments should be returned for the account with payments');
    }

    @IsTest
    static void testGetPaymentsByAccountId_NoPayments() {
        Account acc = [SELECT Id FROM Account WHERE Name='Empty Account' LIMIT 1];
        List<Payment__c> payments = AccountPaymentController.getPaymentsByAccountId(acc.Id);
        System.assertEquals(0, payments.size(), 'No payments should be returned for account without payments');
    }

    
    // createPayment() testi
    @IsTest
    static void testCreatePayment_Valid() {
        Account acc = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
        Payment__c newPay = new Payment__c(
            Payment_Type__c = 'Product',
            Amount__c = 50,
            Due_Date__c = Date.today().addDays(5),
            Notes__c = 'Another Test Payment',
            Account__c = acc.Id
        );

        Test.startTest();
        Payment__c insertedPay = AccountPaymentController.createPayment(newPay);
        Test.stopTest();

        System.assertNotEquals(null, insertedPay.Id, 'Inserted payment should have an Id');
        System.assertEquals('Product', insertedPay.Payment_Type__c, 'Payment Type should match');
    }

    @IsTest
    static void testCreatePayment_NullPayment() {
        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            AccountPaymentController.createPayment(null);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'AuraHandledException should be thrown for null Payment');
    }

    @IsTest
    static void testCreatePayment_PastDueDate() {
        Account acc = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
        Payment__c invalidPay = new Payment__c(
            Payment_Type__c = 'Service',
            Amount__c = 10,
            Due_Date__c = Date.today().addDays(-1), // geçmiş tarih
            Notes__c = 'Invalid Payment',
            Account__c = acc.Id
        );

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            AccountPaymentController.createPayment(invalidPay);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assert(exceptionThrown, 'AuraHandledException should be thrown for past Due Date');
    }
}

