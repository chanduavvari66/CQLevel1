import { LightningElement } from 'lwc';

export default class Lwc_2604_eg1_player extends LightningElement 
{
    vol = 0;
    lbl = 'waiting for the action';
    incvol (event)
    {
        this.lbl = event.detail;
        if(this.vol<100 )
        {
            this.vol = this.vol+1;
        }

    }
    decvol (event)
    {
        
        this.lbl =event.detail;
                if(this.vol>0 )
        {
            this.vol = this.vol-1;
        }


    }
}