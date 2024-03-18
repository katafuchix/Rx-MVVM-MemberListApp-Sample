# Rx-MVVM-MemberListApp-Sample

![Simulator Screen Recording - iPhone 13 Pro - 2022-06-18 at 23 29 27](https://user-images.githubusercontent.com/6063541/174443068-b85c9f72-ee06-41b7-9d32-c27a2fd2b360.gif)

- ViewModel

```
class ViewModel: ViewModelType, ViewModelInputs, ViewModelOutputs {

    var inputs: ViewModelInputs { return self }
    var outputs: ViewModelOutputs { return self }

    // MARK: - Inputs
    let trigger = PublishSubject<Void>()

    // MARK: - Outputs
    let members : BehaviorRelay<[Member]>
    let isLoading: Observable<Bool>
    let error: Observable<ActionError>
    
    // 内部変数
    private let action: Action<(), [Member]>
    private let disposeBag = DisposeBag()
    
    init() {
        
        // メンバー一覧
        self.members = BehaviorRelay<[Member]>(value: [])
        
        // アクション定義
        self.action = Action { _ in
            let urlStr = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"
            let url = URL(string:urlStr)!
            return URLRequest.load(resource: Resource<[Member]>(url: url))
        }
        
        // メンバー
        self.action.elements
            .map { $0 }
            .bind(to:self.members)
            .disposed(by: disposeBag)
        
        // 起動
        self.trigger.asObservable()
            .bind(to:self.action.inputs)
            .disposed(by: disposeBag)
        
        // 検索中
        self.isLoading = action.executing.startWith(false)

        // エラー
        self.error = action.errors
    }

    // データ読み込み
    func loadData() {
        self.members.accept([])
        self.trigger.onNext(())
    }
}
```
