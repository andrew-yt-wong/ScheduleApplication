//  测试数据
var testData = [
	{
		date: '2020-04-04',
		items: [
			{
				status: 0,
				statusName: '未结束',
				classTime: '18:30-19:30<br/>user1',
				className: '今天要干嘛',
				handOutUrl: '1www.baidu.com',
				onlineUrl: '2www.baidu.com',
				color: '#138496',
				downList: [
					{downName: '', downAddress: ''},
				]
			},{
				status: 1,
				statusName: '直播中',
				classTime: '19:30-20:30',
				className: '二建直播2',
				handOutUrl: '3www.baidu.com',
				onlineUrl: '4www.baidu.com',
				color: '#CE8483',
				downList: [
					{downName: '4二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '5二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '6二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			},{
				status: 2,
				statusName: '未开始',
				classTime: '20:30-21:30',
				className: '二建直播3',
				handOutUrl: '5www.baidu.com',
				onlineUrl: '6www.baidu.com',
				color: '#EEA236',
				downList: [
					{downName: '7二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '8二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '9二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			}
		]
	},{
		date: '2020-04-03',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播a',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '11二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '12二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '13二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			}
		]
	},{
		date: '2020-04-02',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '14二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '15二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '16二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			}
		]
	},{
		date: '2020-04-01',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播a',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#CE8483",
				downList: [
					{downName: '17二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '18二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '19二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			}
		]
	},{
		date: '2020-03-31',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '21二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '22二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '23二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			}
		]
	},{
		date: '2020-03-30',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播a',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#EEA236",
				downList: [
					{downName: '24二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '25二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '26二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]
			}
		]
	},{
		date: '2020-03-31',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '27二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '28二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '29二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]	
			}
		]
	},{
		date: '2020-03-31',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#CE8483",
				downList: [
					{downName: '27二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '28二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '29二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]	
			}
		]
	},{
		date: '2020-03-29',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#CE8483",
				downList: [
					{downName: '27二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '28二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '29二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]	
			}
		]
	},{
		date: '2020-03-29',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '27二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '28二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '29二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]	
			}
		]
	},{
		date: '2020-03-29',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '27二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '28二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '29二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]	
			}
		]
	},{
		date: '2020-03-27',
		items: [
			{
				status: 0,
				statusName: '已结束',
				classTime: '18:30-19:30',
				className: '二建直播b',
				handOutUrl: 'www.baidu.com',
				onlineUrl: 'www.baidu.com',
				color: "#007BFF",
				downList: [
					{downName: '27二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '28二建直播课程讲义下载', downAddress: 'www.baidu.com'},
					{downName: '29二建直播课程讲义下载', downAddress: 'www.baidu.com'}
				]	
			}
		]
	}
]