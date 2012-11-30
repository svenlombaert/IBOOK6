/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:52
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.model {
import be.devine.cp3.queue.Queue;
import be.devine.cp3.queue.URLLoaderTask;
import be.devine.cp3.vo.PageVO;

import flash.events.Event;
import flash.events.EventDispatcher;

public class AppModel extends EventDispatcher {
    public static var instance:AppModel;

    public static const PAGES_CHANGED:String = "pagesChanged";
    public static const SELECTEDPAGEINDEX_CHANGED:String = "selectedPageIndexChanged";
    public static const SELECTEDCOLORINDEX_CHANGED:String = "selectedColorIndexChanged";
    public static const IMAGES_DESIGN_PATH:String = "assets/images_design/";
    public static const VIEWMODES_OPENED:String = "viewmodesOpened";

    private var _selectedPageIndex:int;
    private var _selectedColorIndex:uint;
    private var _pages:Vector.<PageVO>;
    private var _queue:Queue;
    private var _timelineView:Boolean = true;
    private var _viewModesOpened:Boolean = false;

    //-----SINGLETON INITIALIZING
    public static function getInstance():AppModel
    {
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

        _queue = new Queue();
        _queue.add(new URLLoaderTask("assets/xml/books.xml"));
        _queue.addEventListener(Event.COMPLETE, queueCompleteHandler);
        _queue.start();
    }

    //----METHODS
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
        if(_viewModesOpened){
            _viewModesOpened = false;
        }else{
            _viewModesOpened = true;
        }
        dispatchEvent(new Event(VIEWMODES_OPENED));
    }

    private function queueCompleteHandler(event:Event):void {
        var completedTask:URLLoaderTask = _queue.completedTasks[0] as URLLoaderTask;
        var xml:XML = new XML(completedTask.data);
        var pages:Vector.<PageVO> = Vector.<PageVO>([]);
        var pagenumber:uint = 0;

        for each(var node:XML in xml.page){
            pagenumber ++;
            trace('[APPMODEL] PAGINA INGELADEN: ', pagenumber);
            var pageVO:PageVO = new PageVO();
            pageVO.pagenumber = pagenumber;
            pageVO.title = node.title;
            pageVO.photo = node.photo;
            for each(var textfield:XML in node.textfields.textfield){
                pageVO.textfields.push(textfield);
            }
            for each(var link:XML in node.links.link){
                pageVO.links.push(link);
            }
            pages.push(pageVO);
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
        }
        dispatchEvent(new Event(SELECTEDPAGEINDEX_CHANGED));
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
        _timelineView = value;
    }

    public function get viewModesOpened():* {
        return _viewModesOpened;
    }

    public function set viewModesOpened(value):void {
        _viewModesOpened = value;
    }
}
}
internal class Enforcer{};
