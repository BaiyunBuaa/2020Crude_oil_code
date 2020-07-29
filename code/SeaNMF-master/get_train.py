def get_train(path1,path2):
    f = open(path1)
    #读取全部内容
    lines = f.readlines()  #lines在这里是一个list
    #获取行数
    nums = len(lines)

    with open(path2,'w') as ff:
        for i in range(int(nums*2/3)):
            ff.write(lines[i])

if __name__ == '__main__':
    path1 = './data/wedata.txt'
    path2 = './data/train_data.txt'
    path3 = './data/wedoc_term_mat.txt'
    path4 = './data/train_doc_term_mat.txt'
    get_train(path1,path2)
    get_train(path3,path4)



