import React, {useState} from "react";
import {api} from "@/services/services";
import TableCharts from "@/components/TableList/TableCharst";
import {getDefaultQuery, getParam} from "@/pages/patent/dashboard/detail";
import SearchNode, {tableToExcel} from "@/components/dashboard/search/searchNode";


const Index = ({location}) => {
    const param = getParam(location);
    const defaultQuery = getDefaultQuery(param);
    const [excelData, setExcelData] = useState(null);
    const renderSimpleForm = (form, handleSearch, handleReset) => {
        let defaultData = [
            {type: 'shujulx', key: '1', value: '数据类型:申请量', closable: true}
        ];
        const disable = {diqu: {...param.disable.diqu, 2: []}};
        defaultData = [...defaultData, ...param.defaultValue];
        return <SearchNode form={form} handleReset={handleReset}
                           handleSearch={handleSearch}
                           exportExcel={tag => {
                               const data = [];
                               for (const item of excelData) {
                                   data.push({
                                       name: item.name,
                                       inventionNum: item.inventionNum,
                                       utilityNum: item.utilityNum,
                                       designNum: item.designNum,
                                       totalNum: item.totalNum
                                   })
                               }
                               tableToExcel("专利区域分析数据", data, ["地区", "发明专利数量", "实用新型专利数量", "外观专利数量", "总数量"]);
                           }}
                           disable={{...param.disable, ...disable}}
                           defaultSearch={defaultData}
                           showSearch={['shujulx', 'diqu', 'hangye','yuefen']}/>
    };


    // 列表需要显示的字段
    const columns = [
        {
            title: '地域',
            dataIndex: 'name',
            width: '200px',
        },
        {
            title: '发明专利数量',
            dataIndex: 'inventionNum',
            width: '100px',
        },
        {
            title: '实用新型数量',
            dataIndex: 'utilityNum',
            width: '100px',
        },
        {
            title: '外观设计数量',
            dataIndex: 'designNum',
            width: '100px',
        },
        {
            title: '总数量',
            dataIndex: 'totalNum',
            width: '100px',
        },

    ];
    // charts x y 轴
    const axis = {
        x: 'name',// x 显示的 key
        y: [{key: "inventionNum", name: "发明专利数量"},// y 轴显示的key 及名称
            {key: "utilityNum", name: "实用新型数量"},
            {key: "designNum", name: "外观设计数量"},
            {key: "totalNum", name: "总数量"}
        ]
    };
    return (
        <TableCharts
            type={"bar"}
            rowKey="code"
            search={renderSimpleForm}
            api={api.patent.area}
            onSearch={(p, res) => res && setExcelData(res.list)}
            axis={axis}
            height={400}
            nodeName="list"
            columns={columns}
            params={defaultQuery}
            rotateCount={60}
        />
    );
};

export default Index;

