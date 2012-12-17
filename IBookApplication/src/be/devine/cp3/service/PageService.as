/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 17/12/12
 * Time: 10:41
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.service {
import be.devine.cp3.config.Config;
import be.devine.cp3.factory.vo.PageVOFactory;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class PageService extends EventDispatcher {
    private var _urlLoader:URLLoader;

    public var pages:Vector.<PageVO>;

    public function PageService() {
    }

    public function load():void{
        _urlLoader = new URLLoader();
        _urlLoader.addEventListener(Event.COMPLETE, xmlLoadedHandler);
        _urlLoader.load(new URLRequest(Config.XMLPATH));
    }

    private function xmlLoadedHandler(event:Event):void {
        trace("LOADED XML");
        var content:XML = new XML(event.target.data);
        var pages:Vector.<PageVO> = new Vector.<PageVO>();
        var i:uint = 1;
        for each (var page:XML in content.page){
            pages.push(PageVOFactory.createFromXML(page, i));
            i++;
        }
        this.pages = pages;
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
