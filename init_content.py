#!/bin/python
# coding: utf-8

from bs4 import BeautifulSoup as BS
import re
import html2text
import json
import os
import requests as r
import sys
import re

reload(sys)
sys.setdefaultencoding("utf-8")

headers = {
	"user-agent": "Mozilla/6.0 (Macintosh; Intel Mac OS X 10.13; rv:57.0) Gecko/20100101 Firefox/57.0",
	"Accept-Encoding": "identity",
	"Accept-Language": "en,en-US;q=0.8,zh-CN;q=0.7,zh;q=0.5,zh-TW;q=0.3,zh-HK;q=0.2",
	"Cache-Control": "no-cache",
	"Connection": "keep-alive",
	"Host": "www.elastic.co",
	"Origin": "https://www.elastic.co",
	"Pragma": "no-cache",
}


class Elastic:
	def __init__(self):
		self.content_url = "https://www.elastic.co/guide/en/elasticsearch/reference/5.4/"
		self.error_count = 0
		self.dict = {}

	"""获取目录"""

	def get_toc(self):
		response = r.get(self.content_url, headers=headers)
		if response.status_code != 200:
			print self.error_count, response.status_code
			if self.error_count >= 10:
				return
			self.error_count += 1
			response = self.get_toc()

		toc_ul = BS(response.content, 'html.parser').select("div.toc > ul.toc")

		with open("SUMMARY.md.bak", "w") as file:
			file.write(html2text.html2text(str(toc_ul[0])))

		with open("SUMMARY.md", "aw") as file:
			file.write("#SUMMARY\n\n\n\n")
		self.mk_ul(toc_ul[0])

	def get_content(self):
		self.dict.items().sort()
		print len(self.dict.items())
		index = 1
		for file_name, value in self.dict.items():
			print index
			index += 1
			# if index < 516:
			# 	continue
			dir_name = os.path.dirname(file_name)
			if len(dir_name) > 0 and not os.path.exists(dir_name):
				os.system(" mkdir -p {dir_name} ".format(dir_name=dir_name))

			specific__format = "{base_url}{specific}".format(base_url=self.content_url, specific=value)
			try:
				response = r.get(specific__format, headers=headers)
			except:
				response = r.get(specific__format, headers=headers)

			if response.status_code != 200:
				pass

			bs = BS(response.content, 'html.parser')
			article = bs.select("#guide > div > div > div.col-xs-12.col-sm-8.col-md-8.guide-section > div.section")
			if len(article) == 0:
				article = bs.select("#guide > div > div > div.col-xs-12.col-sm-8.col-md-8.guide-section > div.chapter")
			if len(article) == 0:
				article = bs.select("#guide > div > div > div.col-xs-12.col-sm-8.col-md-8.guide-section > div.part")

			if len(article) == 0:
				article = bs.select("#guide > div > div > div.col-xs-12.col-sm-8.col-md-8.guide-section > div.glossary")
			if len(article) == 0:
				article = bs.select("#guide > div > div > div.col-xs-12.col-sm-8.col-md-8.guide-section > div.appendix")

			if len(article) != 0:
				html2text.config.BODY_WIDTH = 0
				article_html = str(article[0]).replace("section", "div")
				text = html2text.html2text(article_html)
				re_edit = re.compile('\[edit\]\(.*\)')
				text = re.sub(re_edit, "", text)
				with open(file_name, "aw+") as file:
					file.writelines(text)
			else:
				print specific__format
				exit(0)

	def mk_ul(self, ul_item, dir='', level=1):
		for index, li_item in enumerate(ul_item.select("> li")):
			title = li_item.span.string
			if level == 1:
				index -= 1
			if title != None:
				index += 1
				url = li_item.span.a['href'];

				path_file = "{dir}{name}".format(dir=dir, name=turn_md(preIndex(index) + "_" + title))
				self.dict[path_file] = url

				with open("SUMMARY.md", "aw") as file:
					file.write(
						"{space}* [{title}]({name})\n".format(space=turn_level(level), title=title, name=path_file))

				next_ul = li_item.ul

				if next_ul != None:
					dir_ = dir + preIndex(index) + "_" + escape_name(title) + "/"
					self.mk_ul(next_ul, dir=dir_, level=level + 1)


def turn_level(level):
	level_ = ""
	i = 1
	while i < level:
		level_ += "  "
		i += 1
	return level_


def turn_md(name):
	return "{}.md".format(escape_name(name))


def escape_name(name):
	return str(name.strip()).replace(" ", "_").replace("/", "_").replace("?", "").replace("&", "and").replace("___",
	                                                                                                          "_").replace(
		"__", "_")


def preIndex(index):
	" 补全序号为两位数 "

	idx = str(index)
	if len(idx) == 1:
		return "0" + idx
	return idx


def md_suffix(self, str):
	return str + ".md"


if __name__ == '__main__':
	os.system(" ls |grep -vE 'README.md|init_content.py|change_double_parantess.sh'|xargs rm -rf ")

	elastic = Elastic()
	elastic.get_toc()
	elastic.get_content()

	os.system("noglob find . -type f -name '*.md'|xargs  sed -i '' 's/}}/}} {% endraw %}/g'")
	os.system("noglob find . -type f -name '*.md'|xargs  sed -i '' 's/{{/{% raw %} {{/g'")
