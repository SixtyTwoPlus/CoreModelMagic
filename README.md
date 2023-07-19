# CoreModelMagic
这是一个将Coredata与Model绑定操作的一个工具库

# Install 
```
Cocoapods : pod 'ZHCoreModelMagic'
```
# Get Start
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化数据库
    [ZHCoreModelMagic zh_setupCoreDataWithName:@"DataBase"];
}
```
