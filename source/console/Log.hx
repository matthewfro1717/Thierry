package console;

class Log
{
    public static var INFO:String = "[QuiltEngine/Info] ";

    public static function info(h) {
        trace(INFO + h);
    }  
}