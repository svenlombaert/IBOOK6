/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:52
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.model {
import be.devine.cp3.vo.PageVO;

import flash.events.Event;
import flash.events.EventDispatcher;

public class AppModel extends EventDispatcher {
    public static var instance:AppModel;

    public static const PAGES_CHANGED:String = "pagesChanged";
    public static const SELECTEDPAGEINDEX_CHANGED:String = "selectedPageIndexChanged";
    public static const SELECTEDCOLORINDEX_CHANGED:String = "selectedColorIndexChanged";

    private var _selectedPageIndex:int;
    private var _selectedColorIndex:uint;
    private var _pages:Vector.<PageVO>;

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

    }

    //----METHODS
    public function gotoNextPage():void{
        selectedPageIndex++;
    }

    public function gotoPreviousPage():void{
        selectedPageIndex--;
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
}
}
internal class Enforcer{};
