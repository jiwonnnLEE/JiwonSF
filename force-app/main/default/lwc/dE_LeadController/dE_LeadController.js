import { LightningElement } from 'lwc';
import getLeadList from '@salesforce/apex/DE_LeadController.getLeadList';

export default class DE_LeadController extends LightningElement {
    leadList = [];

    connectedCallback() {
		this.getLeadList();
	}

    getLeadList = async () => {
		try {
			const res = await getLeadList();
			console.log(res, " : Lead res");
            console.log(res.RESULT);
            console.log(res.VALUE);
            this.leadList = res.VALUE;
		} catch (err) {
			console.error('Get Lead List API Error >>>> ', err);
		} 
	} 
}