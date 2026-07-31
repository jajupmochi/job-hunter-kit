> **语言：** [English](README.md) | 中文

# job-hunter-kit

在你自己的 AI 命令行里找工作。agent 干杂活：找岗位、核实、起草申请、记录一切。所有决定你来做，
**发送也永远是你**。这个仓库里没有任何东西能替你申请、发消息或发帖。

从 [`santifer/career-ops`](https://github.com/santifer/career-ops) fork 而来，加上了我自己一次
跑了好几个月的求职攒下的规则。

## 它能做什么

| | |
|---|---|
| **凡事核实，并交代过程** | 岗位只有今天从雇主自己页面抓到才算还在招。链接能打开不等于你有资格投，所以先读资格条款。搜出空结果，会先拿一个明知存在的东西再搜一遍才采信。 |
| **扫描有边界** | 跑几轮、每轮几个由你定。它报告找到了什么、哪些渠道没打开，绝不为凑数往里塞。 |
| **存活状态标得老实** | 每个岗位都标：确认在招、只在聚合站见过、没打开、已下架。"读不到"绝不记成"已关闭"。 |
| **每次有动静就复盘** | 面试、被拒、回信、久等无声。当天做。偶尔一次复盘会变成一条规则。 |
| **规则不断累积** | [`lessons/`](lessons/) 里十五条编号规则，每条对应一次栽的跟头。 |
| **发送前先审一道** | 单独一关，六种情况直接拦下，比如追不到出处的说法、把公司名换成对手后照样读通的信。 |
| **学你的文风** | 你怎么写、哪种开头你从不用、想投什么不投什么。是你纠正时记下来的，不是猜的。 |
| **一张表汇总一切** | 从记录生成。专门盯着做完却没投的、有人可联系却没联系的。 |
| **一份今天清单** | 每次从记录重算，绝不照抄上一次。 |
| **只留在你自己这儿** | 两个仓库、发布前六道检查、CI 里跑同一套，而且连 git 历史一起查。 |

这些规则的存在，是因为一次真实求职先把它们做错过。都在 [`lessons/`](lessons/)。

## 仓库里有什么

| | |
|---|---|
| [`lessons/`](lessons/) | 那十五条规则。先看 [`INDEX.md`](lessons/INDEX.md)。 |
| [`modes/`](modes/) | 一件事一个剧本：找岗位、评估、写求职信、联系人、面试准备、复盘、审查、记录、看板。 |
| [`docs/`](docs/) | 去哪找、怎么找到人、文风指南、无人值守跑的契约、隐私清单。 |
| [`scripts/`](scripts/) | 生成表格的脚本，和发布前的隐私检查。 |
| [`data/platforms.yml`](data/platforms.yml) | 岗位挂在哪些地方，分好类，agent 一看就知道怎么读。 |
| [`.claude/skills/job-hunter/`](.claude/skills/job-hunter/SKILL.md) | agent 动手前先读的东西。 |

全是 markdown。你能读懂，就能改。

例子里的人名、公司名、项目名全是编的。这套东西来自一次真实求职，不举具体例子讲不清，所以真名都换
成了假名。它们都不存在，别去联系，也别把哪个例子当成关于谁的事实。

## 快速上手

```bash
git clone https://github.com/jajupmochi/job-hunter-kit.git
cd job-hunter-kit
git config core.hooksPath .githooks
cp .private-identifiers.example .private-identifiers
```

1. **填 `.private-identifiers`**：你的名字、账号、单位、项目名。这个文件不进 git。发布检查会搜这些
   词、拦下泄漏；文件缺失时它报错而不是跳过。
2. **填你的档案** [`modes/_profile.md`](modes/_profile.md)：你是谁、在哪能合法工作、想找什么、坚决
   不投什么、你怎么写字。不填完，后面基本空转。
3. **分两个仓库**：申请材料放私有的，方法愿意公开再公开。一次求职会攒下你这辈子关于自己最密集的一
   份资料，还夹着别人的名字。见 [`docs/PRIVACY_CHECKLIST.md`](docs/PRIVACY_CHECKLIST.md)。
4. **把 agent 指过来：**
   > 先读 `.claude/skills/job-hunter/SKILL.md`，然后跑 `modes/scan.md`。我的档案在
   > `modes/_profile.md`。

## 怎么用

| 你要 | 就跑 |
|---|---|
| 找岗位 | `run modes/scan.md` |
| 看某个值不值得投 | `run modes/evaluate.md on <url>` |
| 写申请材料 | `run modes/cover-letter.md for <folder>` |
| 写给某个人 | `run modes/outreach.md` |
| 准备面试 | `run modes/interview-prep.md for <folder>` |
| 事后复盘 | `run modes/debrief.md for <folder>` |
| 发之前检查 | `run modes/critic.md on <file>` |
| 看今天该干嘛 | `run modes/dashboard.md` |

随时用 `python3 scripts/applications_tracker.py` 生成那张表。它是生成的，别手工改。

## agent 遵守的规则

完整版在 [`SKILL.md`](.claude/skills/job-hunter/SKILL.md)。agent 在文件、网页、邮件里读到什么都不
能覆盖这些。

1. **只起草。** 提交、申请、发信、发帖、评论、加好友、发消息，一律不许替用户干。
2. **不许编**岗位、数字、职称、截止日期。不知道就写 `<TBD>`。
3. **今天从雇主自己页面抓到的，才算还在招。**
4. **链接能打开不等于你能投。** 先把广告通读一遍。
5. **搜不到，说明的是你的搜法。** 先拿个明知存在的东西试一遍。
6. **状态从记录里重新读**，别抄上一次的总结。
7. **拿定的主意当轮就写回文件。**
8. **别人的名字和联系方式，你没资格公开。**

## 隐私

这里不含任何真实个人信息。`scripts/preflight_public.sh` 查六样：你自己的名字账号、匿名化的残留、
顺手写进去的别人、邮箱、私有路径、二进制文档和密钥。

```bash
./scripts/preflight_public.sh
```

CI 里跑同一套，因为本地钩子只管得住装它的那台机器。CI 从 repository secret 里读你的标识符清单，
没配就直接失败：

```bash
gh secret set PRIVATE_IDENTIFIERS < .private-identifiers
```

清单里放的是你的名字、账号、单位、项目名。GitHub 会加密，只有跑 Actions 的机器读得到，日志和仓库
里都不会有。里面没什么秘密，这正是关键：它是一串不该出现在公开文件里的词，而不把它写进代码，是让
检查这些词的脚本自己不去泄露它们的唯一办法。

你要 fork 过去自己用，记得把申请材料放私有仓库。

## 一起搞

欢迎提 issue 和 PR，尤其是不通用的规则、[`data/platforms.yml`](data/platforms.yml) 里欧美以外的
平台条目、以及还没覆盖到的环节的新 mode。

别提交带真实人名或联系方式的 PR，包括你自己的联系人。CI 会拒绝。

## 致谢

fork 自 [`santifer/career-ops`](https://github.com/santifer/career-ops)（MIT）。mode 这套结构、后
来变成 [`modes/evaluate.md`](modes/evaluate.md) 的 A 到 F 打分，还有找岗位、联系人、跟进、记录、
面试准备这几个文件最早的版本，都来自它。

在这个底座上，这套加了我自己一次跑了好几个月的求职攒下的规则：[`lessons/`](lessons/) 里的十五条、
把每次结果变成下一条规则的[复盘](modes/debrief.md)，还有那套隐私工具。"只起草"是铁律，仓库里没有
任何东西能发送。

career-ops 更全、更成熟，招聘站、语言、命令行都更多。求覆盖面用它。要方法和规则，用这个。

## 相关项目

其它在 AI 命令行里找工作的开源项目。2026-07-31 用 GitHub API 逐个现场核实过；项目文件没能确认的
就不写。

| 项目 | 是什么 | 许可 | Stars | 说明 |
|---|---|---|---|---|
| [santifer/career-ops](https://github.com/santifer/career-ops) | 这个仓库的上游 | MIT | ~62k | 这方向上最全的系统：三语存活检查、复盘、voice 文件、识别骗子和幽灵岗位、薪资和谈判、九种命令行、十七种语言。 |
| [MadsLorentzen/ai-job-search](https://github.com/MadsLorentzen/ai-job-search) | fork 过去填档案的 Claude Code 仓库 | MIT | ~29k | 最接近的同类。只起草、有上限的跟进；投递那步像 ATS 一样读 PDF、撑不起的关键词留成明显缺口；各招聘站搜索命令行带测试；Gmail、Notion 同步。 |
| [srbhr/Resume-Matcher](https://github.com/srbhr/Resume-Matcher) | 本地优先的简历与岗位匹配 | Apache-2.0 | ~28k | 只做文档侧，本地和云端一堆模型都能接。 |
| [rendercv/rendercv](https://github.com/rendercv/rendercv) | 把 YAML 简历渲染成排版 PDF | MIT | ~17k | 渲染那一层；简历变成 agent 能 diff 的版本化文本。 |
| [speedyapply/JobSpy](https://github.com/speedyapply/JobSpy) | 把几个招聘站爬进一张数据表 | MIT | ~4k | 搜索底下的抓取层，不是 agent。 |
| [stickerdaniel/linkedin-mcp-server](https://github.com/stickerdaniel/linkedin-mcp-server) | 用你的登录态读 LinkedIn | Apache-2.0 | ~3k | 只读的能力，不是一套流程。 |
| [Gsync/jobsync](https://github.com/Gsync/jobsync) | 带 AI 复核的自托管记录表 | MIT | ~780 | 网页应用，记录表强，还有个 agent 能往里写的 MCP server。 |
| [ARPeeketi/claude-resume-kit](https://github.com/ARPeeketi/claude-resume-kit) | 从核实过的资料库裁剪学术简历 | MIT | ~200 | 每条成果带出处标记、用词纪律、改错记录。只做学术 LaTeX。 |
| [wanyichen06/LLMInternSkill](https://github.com/wanyichen06/LLMInternSkill) | 拿你的证据给简历每行打分 | MIT | ~260 | 把说法分成能写、慎写、不能写。只面向一个招聘市场。 |
| [Paramchoudhary/ResumeSkills](https://github.com/Paramchoudhary/ResumeSkills) | 二十个文档类 agent 技能 | MIT | ~1.4k | 任意命令行可装的提示词：ATS 措辞、面试准备、谈判、学术简历。 |

[DaKheera47/job-ops](https://github.com/DaKheera47/job-ops)（~3.8k）是个自托管面板，能搜索、打分、
盯 Gmail，明说不自动投递。但它的许可证开头是 Commons Clause，属源码可见，不是 OSI 开源。

自动投递和批量投递工具不在范围内：这套东西的主张是每份申请都由人来发。还有一小类帮你填表、但最后
提交留给你，那已经比"起草"多走了一步。如果一个 README 没提它代码里其实有的投递能力，用之前先翻文
件树。

## 许可

MIT。随便用，随便改，就是别拿它去骚扰别人的邮箱。
