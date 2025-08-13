import { LightningElement, track } from 'lwc';
import insertRecords from '@salesforce/apex/SalesPlanController.insertRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader'; // Import loadScript
import sheetjs from '@salesforce/resourceUrl/sheetjs';

let XLSX;
const fieldMapping = {
    
    'name': 'Name',
    'material': 'Material__c',
    'site': 'Site__c',
    'accountName': 'Account_Name__c',
    'nationality': 'Nationality__c',
    'rating': 'Rating__c',
    'industry': 'Industry__c',
    'annualRevenue': 'AnnualRevenue__c',
    'phone': 'Phone__c',
    
};

export default class FileUpload extends LightningElement {

    @track isLoading = false;
    @track file;
    @track fileName; // 선택한 파일 이름 저장할 변수

    async connectedCallback() {
        try {
            /**
             * Static resource 에 업로드 된 sheetjs load
             */
            
            await loadScript(this, sheetjs);
            XLSX = window.XLSX;
            console.log('XLSX library loaded');
        } catch(error){
            console.error('Error loading XLSX library', error);
        }
      // end
    }

    handleUpload() {
        this.isLoading = true;
        // let toastmsg = {};
 
        // 파일 읽기
        const reader = new FileReader();
        console.log('button clicked');
        reader.onload = event => {
            const result = event.target.result;
            console.log('Type of result:', typeof result);
            console.log('Result length:', result ? result.byteLength : 0);
    
            if (!result || result.byteLength === 0) {
                console.error('File read resulted in an empty buffer');
                this.isLoading = false;
                return;
            }

            try{
                let wb = XLSX.read(result, {
                    type: 'array'
                    , cellText: false
                    , cellDates: true
                });
    
                let first_sheet_name = wb.SheetNames[0];
                let ws = wb.Sheets[first_sheet_name];
    
                // Excel을 Json으로 변환
                let sheet_to_json = XLSX.utils.sheet_to_json(ws, {
                    defval: ''
                    , header: 1
                });
                console.log('sheet_to_json :', sheet_to_json);
    
                // No.로 시작하는 Header 찾아서 해당 행부터 읽기
                let startIndex;
                for (let i = 0; i < sheet_to_json.length; i++) {
                    if (sheet_to_json[i][0] === 'No.') {
                        startIndex = i + 1;
                        break;
                    }
                }

                // 첫번째 행, 헤더 읽기
                let headers = sheet_to_json[0];
                console.log('headers : ',JSON.stringify(headers));

                // 데이터 읽어와서 Record에 저장
                let dataRows = sheet_to_json.slice(1).map(row => {
                    let record = {};
                    
                    // 각각의 컬럼을 필드에 맵핑
                    headers.forEach((header, index) => {
                        const salesforceField = fieldMapping[header]; // 필드 이름 가져오기
                        if (salesforceField) {
                            record[salesforceField] = row[index] || ''; // 필드에 행 데이터를 할당
                        }
                    });
                    
                    return record;
                });

                console.log('Mapped Data Rows:', JSON.stringify(dataRows));

                let headerToJson = sheet_to_json[0]; // 엑셀 헤더 가져오기
    
                // Apex 호출
                insertRecords({ records: dataRows })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Records inserted successfully',
                            variant: 'success',
                        }),
                    );
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                })
                .finally(() => {
                    this.isLoading = false;
                });                
                
            }catch(error){
                let errorMsg = error.body ? error.body.message : (error.message || JSON.stringify(error));
                this.showToast('Error', `Error parsing the XLSX file: ${errorMsg}`, 'error');
                console.error('Error parsing the XLSX file:', errorMsg);
                this.isLoading = false;
            }
        };
        reader.onerror = error => {
            console.error('FileReader error:', error);
            // this.showToast(toastmsg.title, toastmsg.message, toastmsg.variant);
            this.isLoading = false;
        };
        reader.readAsArrayBuffer(this.file);
    }

    
    // 파일 선택 이벤트 처리
    handleFileChange(event) {
        this.file = event.target.files[0];
        console.log('handle File Change successfully');

        const files = event.target.files; // 선택한 파일 가져오기
        if(files.length > 0){
            this.fileName = files[0].name; // 첫번째 파일 이름 저장
            console.log('fileName : ', this.fileName);

        }else{
            this.fileName = ''; // 파일이 선택되지 않았을 경우 초기화
        }

    }


    // 토스트 메시지를 보여주는 메서드
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}