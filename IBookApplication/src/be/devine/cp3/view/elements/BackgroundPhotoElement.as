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
import be.devine.cp3.vo.BackgroundPhotoElementVO;

import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

public class BackgroundPhotoElement extends Element{
    //TODO: Thomas: backgroundphoto element opmaken, eventueel aan de hand van breedte en hoogte vanuit XML (die dus ook in de BackgroundPhotoVO zal zitten)
    private var appModel:AppModel;
    private var image:Image;
    private var loader:URLLoader;

    public function BackgroundPhotoElement(backgroundPhotoElementVO:BackgroundPhotoElementVO) {
        super (backgroundPhotoElementVO);
        appModel = AppModel.getInstance();
        appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);
        image = new Image(Texture.fromBitmapData(new BitmapData(1024, 768)));

        loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(flash.events.Event.COMPLETE, photoLoaded);
        loader.load(new URLRequest(Config.IMAGEPATH_PREFIX + backgroundPhotoElementVO.path));

    }

    private function photoLoaded(event:flash.events.Event):void {
        var texture:Texture = Texture.fromAtfData(loader.data);
        image = new Image(texture);
        var maxwidth:uint = 1024;
        var maxheight:uint = 768;
        image.setTexCoords(1, new Point(maxwidth/texture.width, 0));
        image.setTexCoords(2, new Point(0, 768/texture.height));
        image.setTexCoords(3, new Point(maxwidth/texture.width, maxheight/texture.height));
        image.width = maxwidth;
        image.height = maxheight;

        setSize();
        addChild(image);
        dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
    }

    private function resizeHandler(event:flash.events.Event):void {
        setSize()
    }

    private function setSize():void {
        image.x = appModel.appwidth/2 - image.width/2;
        image.y = appModel.appheight/2 - image.height/2;
    }

}
}