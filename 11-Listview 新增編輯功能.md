## Listview 新增編輯功能

### 模擬 API 呼叫

    Future<List<String>> fetchItems() async {
      // 模擬延遲
      await Future.delayed(const Duration(seconds: 2));
    
      // 模擬從 API 回傳的資料
      return ['Item 1', 'Item 2', 'Item 3'];
    }
    
    Future<void> addItemToAPI(String newItem) async {
      // 模擬延遲
      await Future.delayed(const Duration(seconds: 1));
    
      // 模擬將資料發送到 API
      print('Item "$newItem" added to API');
    }
    
    Future<void> editItemInAPI(int index, String newItem) async {
      // 模擬延遲
      await Future.delayed(const Duration(seconds: 1));
    
      // 模擬編輯資料
      print('Item at index $index edited to "$newItem"');
    }

### `ItemListPage`（主頁面）

    class ItemListPage extends StatefulWidget {
      const ItemListPage({super.key});
    
      @override
      State<ItemListPage> createState() => _ItemListPageState();
    }
    
    class _ItemListPageState extends State<ItemListPage> {
      List<String> items = [];
      bool isLoading = false;
    
      @override
      void initState() {
        super.initState();
        _loadItems();  // 載入資料
      }
    
      Future<void> _loadItems() async {
        setState(() {
          isLoading = true;
        });
        items = await fetchItems();
        setState(() {
          isLoading = false;
        });
      }
    
      void _goToAddPage() async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddItemPage()),
        );
    
        if (result != null && result is String) {
          await addItemToAPI(result);  // 新增資料到 API
          await _loadItems();  // 重新載入資料
        }
      }
    
      void _goToEditPage(int index) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditItemPage(initialValue: items[index])),
        );
    
        if (result != null && result is String) {
          await editItemInAPI(index, result);  // 編輯資料到 API
          await _loadItems();  // 重新載入資料
        }
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text("Item List")),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())  // 顯示載入中的指示器
              : items.isEmpty
                  ? const Center(child: Text("No items yet."))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(items[index]),
                        onTap: () => _goToEditPage(index),  // 點擊進入編輯頁
                      ),
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: _goToAddPage,
            child: const Icon(Icons.add),
          ),
        );
      }
    }

###  AddItemPage（新增頁面）

    class AddItemPage extends StatelessWidget {
      const AddItemPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        final TextEditingController controller = TextEditingController();
    
        return Scaffold(
          appBar: AppBar(title: const Text("Add Item")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: "Item name"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    if (value.isNotEmpty) {
                      Navigator.pop(context, value); // 回傳新值給上層
                    }
                  },
                  child: const Text("Add"),
                )
              ],
            ),
          ),
        );
      }
    }

### EditItemPage（編輯頁面）

    class EditItemPage extends StatelessWidget {
      final String initialValue;
    
      const EditItemPage({super.key, required this.initialValue});
    
      @override
      Widget build(BuildContext context) {
        final TextEditingController controller = TextEditingController(text: initialValue);
    
        return Scaffold(
          appBar: AppBar(title: const Text("Edit Item")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: "Item name"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    if (value.isNotEmpty) {
                      Navigator.pop(context, value); // 回傳修改後的資料
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        );
      }
    }
