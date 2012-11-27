/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 23/11/12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3 {


import be.devine.cp3.model.AppModel;
import be.devine.cp3.queue.Queue;
import be.devine.cp3.queue.URLLoaderTask;
import be.devine.cp3.vo.PageVO;
import flash.events.Event;
import starling.display.Sprite;
import starling.events.KeyboardEvent;

public class Application extends Sprite {

    private var appModel:AppModel;
    private var queue:Queue;

    public function Application() {
        trace('MAIN GEADD');

        appModel = AppModel.getInstance();
        queue = new Queue();
        queue.add(new URLLoaderTask("assets/xml/books.xml"));
        queue.addEventListener(Event.COMPLETE, queueCompleteHandler);
        queue.start();

        this.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardEventHandler);
    }

    //----METHODS
    private function queueCompleteHandler(event:Event):void {
        var completedTask:URLLoaderTask = queue.completedTasks[0] as URLLoaderTask;
        var xml:XML = new XML(completedTask.data);
        var pages:Vector.<PageVO> = Vector.<PageVO>([]);

        for each(var node:XML in xml.page){
            var pageVO:PageVO = new PageVO();
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

        appModel.pages = pages;
    }

    private function keyBoardEventHandler(event:Event):void {
        //keyboard event om door de pagina's te gaan.
    }
}
}
