class Test{
          var uniqueArr: [tempModel] = []
        modelArr.forEach { element in
            if !uniqueArr.contains(where: {$0.id == element.id}) {
                uniqueArr.append(element)
            }
        }
        debugPrint(uniqueArr)
        var tempArr: [tempModel] = uniqueArr
        debugPrint("tempArr : \(tempArr)")
            uniqueArr.forEach { element in
                print(modelArr.filter({$0.id == element.id}))
                if modelArr.filter({$0.id == element.id}).count > 1 {
                    if let index = tempArr.firstIndex(where: {$0.id == element.id}) {
                        tempArr.remove(at: index)
                    }
                }
            }
        tempArr.forEach { tempModel in
            debugPrint(tempModel.id)
        }
            print(tempArr)
}    

