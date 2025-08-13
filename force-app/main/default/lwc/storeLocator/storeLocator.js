import { LightningElement, track } from 'lwc';
import getCoordinates from '@salesforce/apex/NaverGeocodeController.getCoordinates';
import { loadScript } from 'lightning/platformResourceLoader';
import NAVER_MAPS from '@salesforce/resourceUrl/NaverMaps';

export default class StoreLocator extends LightningElement {
    @track stores = [
        { id: 1, name: '서울 본점', address: '서울특별시 중구 세종대로 110' },
        { id: 2, name: '명동 지점', address: '서울특별시 중구 명동길 14' },
        { id: 3, name: '강남 지점', address: '서울특별시 강남구 테헤란로 152' }
    ];

    map;
    marker;

    connectedCallback() {
        loadScript(this, NAVER_MAPS + '/v3/maps.js?ncpClientId=YOUR_CLIENT_ID')
            .then(() => {
                this.initMap();
            })
            .catch(error => {
                console.error('네이버 지도 로드 실패:', error);
            });
    }

    initMap() {
        this.map = new naver.maps.Map(this.template.querySelector('#map'), {
            center: new naver.maps.LatLng(37.5665, 126.9780), // 기본 지도 중심 (서울)
            zoom: 13
        });

        this.marker = new naver.maps.Marker({
            position: new naver.maps.LatLng(37.5665, 126.9780),
            map: this.map
        });
    }

    handleStoreClick(event) {
        const address = event.currentTarget.dataset.address;

        getCoordinates({ address })
            .then(result => {
                if (result.lat && result.lng) {
                    this.updateMap(result.lat, result.lng);
                } else {
                    console.error('주소를 찾을 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('API 오류:', error);
            });
    }

    updateMap(lat, lng) {
        const location = new naver.maps.LatLng(lat, lng);
        this.map.setCenter(location);
        this.marker.setPosition(location);
    }
}