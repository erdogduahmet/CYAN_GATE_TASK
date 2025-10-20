import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountPaymentController.getAccounts';
import getPaymentsByAccountId from '@salesforce/apex/AccountPaymentController.getPaymentsByAccountId';
import createPayment from '@salesforce/apex/AccountPaymentController.createPayment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountPayments extends LightningElement {
    @track accounts = [];
    @track accountsOptions = [];
    @track payments = [];
    @track selectedAccountId = '';
    @track newPayment = {
        Payment_Type__c: '',
        Amount__c: 0,
        Due_Date__c: '',
        Notes__c: ''
    };

    @track paymentTypeOptions = [
        { label: 'Service', value: 'Service' },
        { label: 'Product', value: 'Product' },
        { label: 'Other', value: 'Other' }
    ];

    columns = [
        { label: 'Type', fieldName: 'Payment_Type__c' },
        { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
        { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
        { label: 'Notes', fieldName: 'Notes__c' }
    ];

    //Hesapları çekme ve options oluşturma
    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.accountsOptions = data.map(a => ({ label: a.Name, value: a.Id }));
        } else if (error) {
            this.showToast('Error', 'Unable to load accounts', 'error');
        }
    }

    //Hesap seçildiğinde ödemeleri getirsin
    async handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        if (this.selectedAccountId) {
            try {
                const result = await getPaymentsByAccountId({ accountId: this.selectedAccountId });
                this.payments = result.map(p => ({ ...p })); // Reactive update
            } catch (error) {
                this.showToast('Error', 'Unable to load payments', 'error');
                console.error(error);
            }
        } else {
            this.payments = [];
        }
    }

    //Form input değişimlerini yakala
    handleInputChange(event) {
        const field = event.target.name;
        this.newPayment[field] = event.target.value;
    }

    //Yeni ödeme oluşturma
    async createPaymentRecord() {
        if (!this.selectedAccountId) {
            this.showToast('Error', 'Please select an account first', 'error');
            return;
        }

        let paymentToInsert = { ...this.newPayment, Account__c: this.selectedAccountId };

        try {
            await createPayment({ newPayment: paymentToInsert });
            this.showToast('Success', 'Payment created successfully', 'success');

            //Listeyi güncelle ve reactive yap
            const updatedPayments = await getPaymentsByAccountId({ accountId: this.selectedAccountId });
            this.payments = updatedPayments.map(p => ({ ...p }));

            //Formu temizle
            this.newPayment = {
                Payment_Type__c: '',
                Amount__c: 0,
                Due_Date__c: '',
                Notes__c: ''
            };

        } catch (error) {
            this.showToast('Error', 'Error creating payment', 'error');
            console.error(error);
        }
    }

    //Toast mesaj gösterme
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}
