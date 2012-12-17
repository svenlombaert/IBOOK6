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
    public static const THUMBSCROLLBARPOSITION_CHANGED:String = "thumbScrollbarPositionChanged";
    public static const APPSIZE_CHANGED:String = "appsizeChanged";

    private var _selectedPageIndex:int;
    private var _selectedColorIndex:uint;
    private var _pages:Vector.<PageVO>;
    private var _timelineView:Boolean;
    private var _viewModesOpened:Boolean = false;
    private var _thumbScrollbarPosition:Number;
    private var _maxItemsToView:int;

    private var _appwidth:int;
    private var _appheight:int;

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
    //TODO: xml laden in een service

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
        if(value != _selectedPageIndex){
            if(value == pages.length){
                _selectedPageIndex = pages.length-1;
            }else if(value == -1){
                _selectedPageIndex = 0;
            }else{
                _selectedPageIndex = value;
                dispatchEvent(new Event(SELECTEDPAGEINDEX_CHANGED));
            }
            trace("[APPMODEL] selectedPageIndex: ", selectedPageIndex);
        }

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

    public function get thumbScrollbarPosition():Number {
        return _thumbScrollbarPosition;
    }

    public function set thumbScrollbarPosition(value:Number):void {
        if(value != _thumbScrollbarPosition){
            _thumbScrollbarPosition = value;
            dispatchEvent(new Event(THUMBSCROLLBARPOSITION_CHANGED));
        }
    }

    public function get maxItemsToView():int {
        return _maxItemsToView;
    }

    public function set maxItemsToView(value:int):void {
        _maxItemsToView = value;
    }

    public function get appheight():int {
        return _appheight;
    }

    public function set appheight(value:int):void {
        if(_appheight != value){
            _appheight = value;
            dispatchEvent(new Event(APPSIZE_CHANGED));
        }
    }

    public function get appwidth():int {
        return _appwidth;
    }

    public function set appwidth(value:int):void {
        if(value != _appwidth){
            _appwidth = value;
            dispatchEvent(new Event(APPSIZE_CHANGED));
        }
    }
}
}
internal class Enforcer{}
