import { LightningElement, track } from 'lwc';
import getCompany from '@salesforce/apex/SalesPlanController.getCompany';
import fileUpload from 'c/fileUpload'; // fileUpload 컴포넌트 import

export default class CompanyList extends LightningElement {

    @track filedData = []; // 데이터를 저장할 변수
    error;

    connectedCallback() {
        this.companyTable();
    }

    async companyTable() {
        try {
            // await으로 Apex 메서드 호출을 대기
            const result = await getCompany();
            this.filedData = result.map((item, index) => {
                return { ...item, idx: index + 1};
            });
            console.log('filedData : ', JSON.stringify(this.filedData));
        } catch (error) {
            // 오류 처리
            this.error = error;
            console.log('companyTeble Error : ', error);
        }
    }
}