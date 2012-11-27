/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 28/09/12
 * Time: 11:05
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.queue {
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;

public class ImageLoaderTask extends Loader implements IQueue{

     private var imageURL:String;

    public function ImageLoaderTask(imageURL:String) {
        this.imageURL = imageURL;
    }

    public function start():void{
        this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        this.load(new URLRequest(imageURL));
    }

    private function completeHandler(event:Event):void {
        this.dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
