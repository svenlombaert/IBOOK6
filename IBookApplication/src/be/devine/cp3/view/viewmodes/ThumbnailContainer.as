/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 3/12/12
 * Time: 14:34
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.viewmodes {
import be.devine.cp3.config.Config;
import be.devine.cp3.model.AppModel;
import be.devine.cp3.utils.memory.ClearMemory;

import flash.events.Event;

import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.TextureAtlas;
import starling.utils.HAlign;

public class ThumbnailContainer extends Sprite {
    private var background:Quad;
    private var appModel:AppModel;
    private var toolTip:Image;
    private var prevNextText:TextField;
    private var openText:TextField;
    private var _timelineView:Boolean;
    private var _arrThumbnails:Vector.<Thumbnail>;
    private var timelineThumbnails:TimelineThumbnails;
    private var gridviewThumbnails:GridviewThumbnails;
    private var container:Sprite;

    public function ThumbnailContainer(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);
        this.appModel.addEventListener(AppModel.VIEWMODES_CHANGED, viewmodesChangedHandler);
        _timelineView = appModel.timelineView;
        background = new Quad(AppModel.instance.appwidth, AppModel.instance.appheight, Config.TIMELINECOLOR);
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

        container = new Sprite();
        container.x = 30;
        container.y = 100;
        addChild(container);

        generateThumbs();
    }

    private function generateThumbs():void {
        trace('ik genereer thumbs');
        _arrThumbnails = new Vector.<Thumbnail>();
        for (var i:int = 0; i<appModel.pages.length; i++ )
        {
            var thumb:Thumbnail = new Thumbnail("assets/images/thumbnails/thumbnail" + i + ".atf", i);
            _arrThumbnails.push(thumb);
        }
        generateDiffViews();
    }

    private function generateDiffViews():void{
        showRightViewmode();
    }

    private function showRightViewmode():void {
            if(_timelineView){
                timelineThumbnails= new TimelineThumbnails(_arrThumbnails);
                timelineThumbnails.display(appModel.selectedPageIndex);
                trace('ja');
                trace("CONTAINER: ",container.x,  container.y);
                //trace("TIMELINE: ",timelineThumbnails.x,  timelineThumbnails.y);
                if(gridviewThumbnails != null){
                    ClearMemory.clear(gridviewThumbnails as DisplayObjectContainer);
                }
                container.removeChild(gridviewThumbnails, true);
                container.addChild(timelineThumbnails);
            }else{
                gridviewThumbnails= new GridviewThumbnails(_arrThumbnails);
                gridviewThumbnails.display(appModel.selectedPageIndex);
                if(timelineThumbnails != null){
                    ClearMemory.clear(timelineThumbnails as DisplayObjectContainer);
                }
                container.removeChild(timelineThumbnails, true);
                container.addChild(gridviewThumbnails);
            }
    }


    private function display():void{
        background.width = appModel.appwidth;
        background.height = appModel.appheight;
    }


    private function resizeHandler(event:Event):void {
        display();
    }

    private function viewmodesChangedHandler(event:Event):void {
        trace(appModel.timelineView);
        _timelineView = appModel.timelineView;
        showRightViewmode();
    }
}
}
