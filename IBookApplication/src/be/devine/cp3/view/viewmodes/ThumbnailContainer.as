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

import flash.events.Event;
import flash.filesystem.File;

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

    public function ThumbnailContainer(textureAtlas:TextureAtlas) {
        appModel = AppModel.getInstance();
        this.appModel.addEventListener(AppModel.APPSIZE_CHANGED, resizeHandler);

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

        getUrls();
    }

    private function getUrls():void{
        var phDirectory:File = File.desktopDirectory.resolvePath("thumbnails");
        phDirectory.createDirectory();

        var files:Array = phDirectory.getDirectoryListing();
        var urls:Vector.<String> = new Vector.<String>();

        for each(var f:File in files){
            // controle dat het zeker fotos zijn
            if(!f.isDirectory){
                var filesplit:Array = f.name.split(".");
                switch(filesplit[filesplit.length - 1]){
                    case 'jpg':
                    case 'jpeg':
                    case 'gif':
                    case 'png':
                        urls.push(f.url);
                        break;
                }
            }

        }
        appModel.thumbnailUrls = urls;
        generateThumbs();

    }

    private function generateThumbs():void {
        _arrThumbnails = new Vector.<Thumbnail>();
        var i:int = 0;
        for each(var url:String in appModel.thumbnailUrls){
            trace('url: ', url);
            var thumb:Thumbnail = new Thumbnail(url, i);
            _arrThumbnails.push(thumb);
            i++
        }
        showThumbnails();
    }

    private function showThumbnails():void {
        if(appModel.timelineView){
            trace('Show timelineview');
            var timelineThumbnails:TimelineThumbnails = new TimelineThumbnails(_arrThumbnails);
            timelineThumbnails.x = 30;
            timelineThumbnails.y = 258 - Thumbnail.MAXHEIGHT - 20;
            addChild(timelineThumbnails);
        }else{
            trace('show gridview');
        }
    }

    private function display():void{
        background.width = appModel.appwidth;
        background.height = appModel.appheight;
    }


    private function resizeHandler(event:Event):void {
        display();
    }

    public function get timelineView():Boolean {
        return _timelineView;
    }

    public function set timelineView(value:Boolean):void {
        _timelineView = value;
        showThumbnails();
    }
}
}
