/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:52
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.model {
import be.devine.cp3.factory.vo.PageVOFactory;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class AppModel extends EventDispatcher {
    public static var instance:AppModel;

    public static const PAGES_CHANGED:String = "pagesChanged";
    public static const SELECTEDPAGEINDEX_CHANGED:String = "selectedPageIndexChanged";
    public static const SELECTEDCOLORINDEX_CHANGED:String = "selectedColorIndexChanged";
    public static const VIEWMODES_OPENED:String = "viewmodesOpened";
    public static const VIEWMODES_CHANGED:String = "viewmodesChanged";

    private var _selectedPageIndex:int;
    private var _selectedColorIndex:uint;
    private var _pages:Vector.<PageVO>;
    private var _timelineView:Boolean;
    private var _viewModesOpened:Boolean = false;
    private var _urlLoader:URLLoader;

    public var appwidth:int;
    public var appheight:int;

    //-----SINGLETON INITIALIZING
    public static function getInstance():AppModel{
       if(instance == null)
       {
            instance = new AppModel(new Enforcer());
       }
       return instance;
    }

    //-----CONSTRUCTOR
    public function AppModel(e:Enforcer) {
        if(e == null)
        {
           throw new Error("AppModel is a Singleton");
        }
    }

    //----METHODS
    public function load():void{
        _urlLoader = new URLLoader();
        _urlLoader.addEventListener(Event.COMPLETE, xmlLoadedHandler);
        _urlLoader.load(new URLRequest("assets/xml/books.xml"));
    }
    public function gotoNextPage():void{
        trace('[APPMODEL] gotonextpage');
        selectedPageIndex++;
    }

    public function gotoPreviousPage():void{
        trace('[APPMODEL] gotopreviouspage');
        selectedPageIndex--;
    }

    public function openViewModes():void{
        trace('[APPMODEL] openviewmodes');
        if(viewModesOpened){
            viewModesOpened = false
        }else{
            viewModesOpened = true;
        }
    }

    public function changeViewModes():void{
        if(timelineView){
            timelineView = false
        }else{
            timelineView = true;
        }
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
    }

    //----GETTERS EN SETTERS
    public function get pages():Vector.<PageVO> {
        return _pages;
    }

    public function set pages(value:Vector.<PageVO>):void {
        _pages = value;
        dispatchEvent(new Event(PAGES_CHANGED));
        trace('[APPMODEL] PAGES CHANGED');
    }

    public function get selectedPageIndex():int {
        return _selectedPageIndex;
    }

    public function set selectedPageIndex(value:int):void {
        if(value == pages.length){
                _selectedPageIndex = pages.length-1;
        }else if(value == -1){
                _selectedPageIndex = 0;
        }else{
                _selectedPageIndex = value;
                dispatchEvent(new Event(SELECTEDPAGEINDEX_CHANGED));
        }
        trace(_selectedPageIndex);
    }

    public function get selectedColorIndex():uint {
        return _selectedColorIndex;
    }

    public function set selectedColorIndex(value:uint):void {
        if(value != _selectedColorIndex){
            _selectedColorIndex = value;
            dispatchEvent(new Event(SELECTEDCOLORINDEX_CHANGED));
        }
    }

    public function get timelineView():Boolean {
        return _timelineView;
    }

    public function set timelineView(value:Boolean):void {
        if(value != _timelineView){
            _timelineView = value;
            trace('DISPATCH viewmodes changed');
            dispatchEvent(new Event(VIEWMODES_CHANGED));
        }
    }

    public function get viewModesOpened():* {
        return _viewModesOpened;
    }

    public function set viewModesOpened(value:Boolean):void {
        if(_viewModesOpened != value){
            _viewModesOpened = value;
            dispatchEvent(new Event(VIEWMODES_OPENED));
        }
    }

}
}
internal class Enforcer{}
