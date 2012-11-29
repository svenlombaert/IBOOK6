/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 28/09/12
 * Time: 09:08
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.queue {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;

public class Queue extends EventDispatcher{

    private var tasks:Array;
    private var totalTasks:uint;
    private var currentTask:IQueue;
    public var completedTasks:Array;

    public function Queue() {

        tasks = new Array();
        totalTasks = 0;
        completedTasks = new Array();
    }

    public function add(task:IQueue):void{
        tasks.push(task);
        totalTasks++;
    }

    public function start():void{

        if(tasks.length > 0)
        {
            currentTask = tasks.shift();
            currentTask.addEventListener(Event.COMPLETE, currentTaskcompleteHandler);
            currentTask.start()
        }else{

            dispatchEvent(new Event(Event.COMPLETE));
        }
    }

    private function currentTaskcompleteHandler(event:Event):void {

        completedTasks.push(event.target);

        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, completedTasks.length, totalTasks));

        start();
    }

}
}
