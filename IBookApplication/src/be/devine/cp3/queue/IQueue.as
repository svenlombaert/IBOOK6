/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 28/09/12
 * Time: 11:13
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.queue {
import flash.events.IEventDispatcher;

public interface IQueue extends IEventDispatcher {
    function start():void;
}
}
