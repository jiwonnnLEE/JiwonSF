import { LightningElement, track, wire, api } from 'lwc';
import label_totalListNum from '@salesforce/label/c.label_totalListNum';
import getSearchList from '@salesforce/apex/OrderListController.getSearchList';
 
 
export default class OrderList extends LightningElement {
    @track resultList = [];
   
    //선택된 값을 저장함
    userSelect = {
        searchOption:'OrderNum', searchSt:''
    };
 
    // 검색옵션
    searchOption = [
        {label : '주문번호', value : 'OrderNum'},
        {label : '자재명', value : 'ProdName'}
    ]
 
    searchOptionChange(e) {this.userSelect.searchOption = e.target.value;}
    searchStChange(e) {this.userSelect.searchSt = e.target.value;}
 
    async connectedCallback() {
        let result = await getSearchList();
        console.log('result:', JSON.parse(JSON.stringify(result)));
       
        this.resultList = result;
       
    }
 
     // 검색버튼
    async searchBtnAction(e) {
        console.log(this.userSelect.searchOption, this.userSelect.searchSt);
        let searchResult = await getSearchList({searchOption: this.userSelect.searchOption, searchSt: this.userSelect.searchSt});
        console.log('searchResult:', JSON.parse(JSON.stringify(searchResult)));

    }


    // 조회된 검색글 개수
    get totalListNum() {
        let totalLabel = label_totalListNum.replace("{0}", this.resultList.recordCnt);
       
        return totalLabel;
    }
   
}