/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 28/09/12
 * Time: 11:52
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.queue {

import flash.net.NetConnection;

public class AmfTask extends NetConnection implements IQueue{

    private var args:Array;
    private var gateway:String;

    public function AmfTask(gateway:String,  args:Array){

       this.args = args;
       this.gateway = gateway;
    }

    public function start():void{
        this.connect(gateway);
        call.apply(this, args);
    }

}
}
