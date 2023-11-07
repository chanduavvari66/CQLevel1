// import { LightningElement, api } from 'lwc';

// export default class FileUpload extends LightningElement {
//    @api
//    myRecordId;
//     get acceptedFormats() {
//         return ['.pdf', '.png', '.jpeg','.jpg'];
//     }

//     handleUploadFinished(event) {
//         // Get the list of uploaded files
//         const uploadedFiles = event.detail.files;
//         alert('No. of files uploaded : ' + uploadedFiles.length);
//     }
// }
import { LightningElement, track,api } from 'lwc';  
import getDocumentSize from '@salesforce/apex/uploadsizecontrol.getDocumentSize';
import deleteDocument from '@salesforce/apex/uploadsizecontrol.deleteDocument';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Fileupload extends LightningElement {
    get acceptedFormats() {
        return ['.pdf', '.png', '.jpeg','.jpg'];
    }
    async handleUploadFinished(event) {
        const fileUploaded = event.detail.files;
        try {
                const file = fileUploaded[0];  
                const checkDocSize = await getDocumentSize({docId : file.documentId});
                if(checkDocSize == true) {
                    const toastEvent = new ShowToastEvent({
                        message: 'File cannot be uploaded as it exceeds the maximum size of 1MB',
                        variant: 'error'
                    });
                    this.dispatchEvent(toastEvent);
               deleteDocument({fileId:file.documentId})
               .then(result => {
                   this.filedetails = result;
                   this.error = undefined;
               })
               .catch(error => {
                   this.error = error;
                   this.accounts = undefined;
               })
                }
                else {
                    alert('File uploaded successfully')                 
                }
        } catch(e) {
            console.error('Error during file upload:',error);
        }
}
}