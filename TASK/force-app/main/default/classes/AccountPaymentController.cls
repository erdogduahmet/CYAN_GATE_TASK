public with sharing class AccountPaymentController {

    // Hesapları çekiyoruz
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        try {
            return [SELECT Id, Name FROM Account ORDER BY Name];
        } catch(Exception e) {
            throw new AuraHandledException('Unable to fetch accounts: ' + e.getMessage());
        }
    }

    // Seçili Account ID’ye ait ödemeleri çekiyoruz
    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPaymentsByAccountId(Id accountId) {
        try {
            return [
                SELECT Id, Payment_Type__c, Amount__c, Due_Date__c, Notes__c
                FROM Payment__c
                WHERE Account__c = :accountId
                ORDER BY Due_Date__c DESC
            ];
        } catch(Exception e) {
            throw new AuraHandledException('Unable to fetch payments: ' + e.getMessage());
        }
    }

    // Yeni Payment ekliyoruz
    @AuraEnabled
    public static Payment__c createPayment(Payment__c newPayment) {
        if (newPayment == null) {
            throw new AuraHandledException('Payment cannot be null');
        }

        // Due Date kontrolü yapıyoruz
        if (newPayment.Due_Date__c <= Date.today()) {
            throw new AuraHandledException('Due Date must be a future date');
        }

        try {
            insert newPayment;
            return newPayment;
        } catch(DmlException e) {
            throw new AuraHandledException('Error inserting payment: ' + e.getMessage());
        }
    }
}
