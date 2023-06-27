const apiDevBaseRoute = "http://192.168.0.131:5022/api";
bool useDev = true;
final apiRoute = useDev ? apiDevBaseRoute : "http://localhost";
