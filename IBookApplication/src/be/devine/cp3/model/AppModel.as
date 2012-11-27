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

    public static const PAGES_CHANGED:String = "pagesChanged";

    private static var instance:AppModel;

    private var _pages:Vector.<PageVO>;

    public static function getInstance():AppModel
    {
       if(instance == null)
       {
            instance = new AppModel(new Enforcer());
       }

       return instance;
    }

    //constructor
    public function AppModel(e:Enforcer) {

        if(e == null)
        {
           throw new Error("AppModel is a Singleton");
        }

    }


    //getters en setters
    public function get pages():Vector.<PageVO> {
        return _pages;
    }

    public function set pages(value:Vector.<PageVO>):void {
        if(value != _pages){
            _pages = value;
            dispatchEvent(new Event(PAGES_CHANGED));
        }
    }
}
}
internal class Enforcer{};
