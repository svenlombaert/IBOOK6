/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 14:34
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;
import be.devine.cp3.style.Style;
import be.devine.cp3.view.Page;
import be.devine.cp3.view.parts.Thumbnail;
import be.devine.cp3.view.parts.TimelineThumbnails;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;

import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.HAlign;

public class ThumbnailContainer extends Sprite {
    private var background:Quad;
    private var appModel:AppModel;
    private var arrThumbnails:Vector.<Thumbnail>;
    private var toolTip:Image;
    private var prevNextText:TextField;
    private var openText:TextField;

    public function ThumbnailContainer(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);

        background = new Quad(AppModel.instance.appwidth, AppModel.instance.appheight, Style.TIMELINECOLOR);
        background.alpha = 0.90;
        addChild(background);

        toolTip = new Image(textureAtlas.getTexture("keyLegend"));
        addChild(toolTip);
        toolTip.y = 10;
        toolTip.x = 100;

        prevNextText = new TextField(100, 20, "prev/next page", "HelveticaNeue", 12, 0xffffff);
        prevNextText.hAlign = HAlign.LEFT;
        openText = new TextField(100, 20, "open viewmodes", "HelveticaNeue", 12, 0xffffff);
        openText.hAlign = HAlign.LEFT;

        prevNextText.x = 100 + prevNextText.width + 20;
        prevNextText.y = 20;
        openText.x = 100 + openText.width + 20;
        openText.y =  prevNextText.height + 25;
        addChild(prevNextText);
        addChild(openText);

        initializeThumbnails();
    }

    private function initializeThumbnails():void{
        arrThumbnails = new Vector.<Thumbnail>();
        for each(var pageVO:PageVO in appModel.pages){
            var thumbnail:Thumbnail = new Thumbnail(new Page(pageVO));
            arrThumbnails.push(thumbnail);
        }
        showThumbnails();
    }

    private function showThumbnails():void{
        if(appModel.timelineView){
            var timelineThumbnails:TimelineThumbnails = new TimelineThumbnails(arrThumbnails);
            timelineThumbnails.x = 30;
            timelineThumbnails.y = 258/2 - timelineThumbnails.height/2 + 20;
            addChild(timelineThumbnails);
        }
    }

    private function display():void{
        background.width = appModel.appwidth;
        background.height = appModel.appheight;
    }


    private function resizeHandler(event:Event):void {
        display();
    }
}
}
