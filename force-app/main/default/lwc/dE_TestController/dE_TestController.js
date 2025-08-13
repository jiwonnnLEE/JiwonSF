import { LightningElement } from 'lwc';
import getTestList from '@salesforce/apex/DE_TestController.getTestList';

export default class DE_TestController extends LightningElement {
    testList = [];

    connectedCallback() {
		this.getTestList();
	}

    getTestList = async () => {
		try {
			const res = await getTestList();
			console.log(res, " : Test res");
            console.log(res.RESULT);
            console.log(res.VALUE);
            this.testList = res.VALUE;
		} catch (err) {
			console.error('Get Test List API Error >>>> ', err);
		} 
	} 
}