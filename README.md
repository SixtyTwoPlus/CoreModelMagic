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
    //初始化数据库，并自动迁移
    [ZHCoreModelMagic zh_setupCoreDataWithAutoMigratingSqliteName:@"DataBase"]
}
```
# 设置数据发生变动代理
```
{
    [ZHCoreModelMagic zh_setupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate delegate:(id<ZHCoreModelMagicObsDelegate>)delegate]
}
```
## 更新数据监听条件
```
{
    [ZHCoreModelMagic zh_resetupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate]
}
```
