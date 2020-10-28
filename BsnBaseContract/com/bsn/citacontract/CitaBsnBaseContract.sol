pragma solidity ^0.4.24; 

/* 
Hitchens UnorderedKeySet v0.93
Library for managing CRUD operations in dynamic key sets.
https://github.com/rob-Hitchens/UnorderedKeySet
Copyright (c), 2019, Rob Hitchens, the MIT License
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
THIS SOFTWARE IS NOT TESTED OR AUDITED. DO NOT USE FOR PRODUCTION.
*/

contract CitaBsnBaseContract {
    
    struct DataBase {
        mapping(bytes32 => uint) keyPointers;
        bytes32[] baseKeyList;
        bytes[] baseValueList;
    }
    
    DataBase self;
    
	//插入数据
    function insert(bytes32 baseKey, bytes baseValue) public {
        require(baseKey != 0x0, "UnorderedKeySet(100) - Key cannot be 0x0");
        require(!exists(baseKey), "UnorderedKeySet(101) - Key already exists in the set.");
        self.keyPointers[baseKey] = self.baseKeyList.push(baseKey)-1;
        self.baseValueList.push(baseValue);
    }
    
	//删除数据
    function remove(bytes32 baseKey) public {
        require(exists(baseKey), "UnorderedKeySet(102) - Key does not exist in the set.");
        bytes32 keyToMove = self.baseKeyList[count()-1];
        bytes bytesToMove = self.baseValueList[count()-1];
        uint rowToReplace = self.keyPointers[baseKey];
        self.keyPointers[keyToMove] = rowToReplace;
        self.baseKeyList[rowToReplace] = keyToMove;
        self.baseValueList[rowToReplace] = bytesToMove;
        delete self.keyPointers[baseKey];
        self.baseKeyList.length--;
        self.baseValueList.length--;
    }
    
	//更新数据
    function update(bytes32 baseKey, bytes baseValue) public {
        require(exists(baseKey), "UnorderedKeySet(102) - Key does not exist in the set.");
        uint rowToModify = self.keyPointers[baseKey];
        self.baseValueList[rowToModify] = baseValue;
    }
    
	//查询数据
    function retrieve(bytes32 baseKey) public view returns(bytes) {
        require(exists(baseKey), "UnorderedKeySet(102) - Key does not exist in the set.");
        uint rowToQuery = self.keyPointers[baseKey];
        return self.baseValueList[rowToQuery];
    }
    
	//获取存储的数据数量
    function count() private view returns(uint) {
        return(self.baseKeyList.length);
    }
    
    function exists(bytes32 baseKey) private view returns(bool) {
        if(self.baseKeyList.length == 0) return false;
        return self.baseKeyList[self.keyPointers[baseKey]] == baseKey;
    }
    
	//获取当前index的key
    function keyAtIndex(uint index) view returns(bytes32) {
        return self.baseKeyList[index];
    }

}