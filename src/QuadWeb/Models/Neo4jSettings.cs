namespace QuadWeb.Models;

public class Neo4jSettings
{
    public string Uri { get; set; } = "bolt://127.0.0.1:7687";
    public string Database { get; set; } = "neo4j";
    public string Username { get; set; } = "neo4j";
    public string Password { get; set; } = "";
}
