package kabam.lib.console.model {
internal final class ActionHistory {

    public function ActionHistory() {
        this.stack = new Vector.<String>();
        this.index = 0;
    }

    private var stack:Vector.<String>;
    private var index:int;

    public function get length():int {
        return (this.stack.length);
    }

    public function add(_arg1:String):void {
        this.index = this.stack.push(_arg1);
    }

    public function getPrevious():String {
        return ((((this.index > 0)) ? this.stack[--this.index] : ""));
    }

    public function getNext():String {
        return ((((this.index < (this.stack.length - 1))) ? this.stack[++this.index] : ""));
    }

}
}
