/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 4/12/12
 * Time: 15:59
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.elements {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.queue.ImageLoaderTask;
import be.devine.cp3.queue.Queue;
import be.devine.cp3.vo.BackgroundPhotoElementVO;

import flash.display.Bitmap;

import flash.events.Event;

import starling.display.Image;

public class BackgroundPhotoElement extends Element{
    //TODO: Thomas: backgroundphoto element opmaken, eventueel aan de hand van breedte en hoogte vanuit XML (die dus ook in de BackgroundPhotoVO zal zitten)
    private var _requestQueue:Queue;
    private var appModel:AppModel;

    public function BackgroundPhotoElement(backgroundPhotoElementVO:BackgroundPhotoElementVO) {
        super (backgroundPhotoElementVO);

        appModel = AppModel.getInstance();

        _requestQueue = new Queue();
        _requestQueue.add(new ImageLoaderTask('assets/images/' + backgroundPhotoElementVO.path));
        _requestQueue.addEventListener(Event.COMPLETE, photoLoaded);
        _requestQueue.start();
    }

    private function photoLoaded(event:Event):void {
        var loadedImage:ImageLoaderTask = _requestQueue.completedTasks[0] as ImageLoaderTask;
        var bitmap:Bitmap = loadedImage.content as Bitmap;
        var image:Image = Image.fromBitmap(bitmap);
        if (appModel.appwidth) {
            image.width = appModel.appwidth;
        }
        if (appModel.appheight) {
            image.height = appModel.appheight;
        }
        addChild(image);
    }
}
}
