import { LightningElement } from 'lwc';
import getOpptyRecord from '@salesforce/apex/OpptyController.getOpptyRecord';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Account', fieldName: 'AccountUrl',type: 'url', typeAttributes: {label: {fieldName: 'AccountName'},target:'_blank'}},
    { label: 'StageName', fieldName: 'StageName', type: 'text' },
    { label: 'CloseDate', fieldName: 'CloseDate', type: 'date' },
    { label: 'Owner', fieldName: 'OwnerName', type: 'text' },
];


export default class OpptyReport extends LightningElement {
    records = [];
    columns = columns;
    connectedCallback() {
        getOpptyRecord().then((data) =>{     
            this.records = data.map((record) => {
                return this.mapOppty(record);
            });
            console.log('완료!!');
            console.log('RESULT-->', JSON.stringify(this.records));
            
        }).catch((error) =>{
            console.log('error while fetch contacts--> ' + JSON.stringify(error));
            
        });
    }

    mapOppty(record) {
        console.log(record);
        var AccountUrl = ''; 
        var AccountName = '';
        var OwnerName = '';
        if (record.AccountId !== undefined) {
            AccountUrl = `/${record.AccountId}`;
            AccountName = record.Account.Name;
            OwnerName = record.Owner.Name;
            console.log('메롱',AccountName+'/'+OwnerName);
        }
    
        return {
            ...record,
            AccountName: AccountName,
            AccountUrl: AccountUrl,
            OwnerName : OwnerName
        };
    };
}