const baseUrl =
    String.fromEnvironment('Server_Url', defaultValue: "192.168.0.130:5022");

const apiRoute = "http://${baseUrl}/api";
const wsRoute = "ws://${baseUrl}/ws";
