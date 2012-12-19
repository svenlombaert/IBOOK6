/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:59
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.config.Config;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.queue.ImageLoaderTask;
import be.devine.cp3.queue.Queue;
import be.devine.cp3.vo.BackgroundPhotoElementVO;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

public class BackgroundPhotoElement extends Element{
    //TODO: Thomas: backgroundphoto element opmaken, eventueel aan de hand van breedte en hoogte vanuit XML (die dus ook in de BackgroundPhotoVO zal zitten)
    private var _requestQueue:Queue;
    private var appModel:AppModel;
    private var image:Image;

    public function BackgroundPhotoElement(backgroundPhotoElementVO:BackgroundPhotoElementVO) {
        super (backgroundPhotoElementVO);

        appModel = AppModel.getInstance();
        appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);

        image = new Image(Texture.fromBitmapData(new BitmapData(100, 100)));
        _requestQueue = new Queue();
        _requestQueue.add(new ImageLoaderTask(Config.IMAGEPATH_PREFIX + backgroundPhotoElementVO.path));
        _requestQueue.addEventListener(flash.events.Event.COMPLETE, photoLoaded);
        _requestQueue.start();
    }

    private function photoLoaded(event:flash.events.Event):void {
        var loadedImage:ImageLoaderTask = _requestQueue.completedTasks[0] as ImageLoaderTask;
        var bitmap:Bitmap = loadedImage.content as Bitmap;
        image = Image.fromBitmap(bitmap);
//        if (appModel.appwidth) {
//            image.width = appModel.appwidth;
//        }
//        if (appModel.appheight) {
//            image.height = appModel.appheight;
//        }

        setSize();
        addChild(image);
        dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
    }

    private function resizeHandler(event:flash.events.Event):void {
        setSize()
    }

    private function setSize(){
        //TODO: proper scaling
        if(appModel.appwidth > appModel.appheight){
            image.width = appModel.appwidth;
            // we willen de image niet uitrekken, maar de img proportioneel scalen
            // width en scaleX ; height en scaleY zijn gelinkt aan elkaar
            // scaleX en scaleY geven mee hoeveel de image geresized is dus:
            // .width aanpassen --> scaleX zal worden aangepast en dus scaleY ook, waardoor de .height wordt aangepast
            image.scaleY = image.scaleX;
        }else if(appModel.appheight > image.height){
            image.height = appModel.appheight;
            image.scaleY = image.scaleX;
        }
    }

}
}