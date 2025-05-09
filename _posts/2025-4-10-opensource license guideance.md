---
title: 开源许可证指南
date: 2025-4-10 8:0:00 +0800
lastUpdateTime: 2025-5-9 18:24:00 +0800
name: opensource license guideance
author: "motorao"
layout: post
tags: 
    - 技术
    - 开源
    - OpenSource
categories: tech
subtitle: opensource license guideance
---
    
# 1. 什么是许可证？

**开源软件并非没有限制**，通俗地说，许可证即授权条款，用于约定如何使用、修改和重新分发开源软件，以此表达对作者著作权和所有参与者贡献的尊重。

## 1.1 在哪里找到许可证

1. **通过git项目查询**

以 [kubernetes](https://github.com/kubernetes/kubernetes) 为例，仓库根目录下的`LICENSE`文件或GitHub页面上的License标签即为许可证说明。

![](https://static.motorao.cn/assets/pic/1ad9fe61-9db0-80f8-9cf2-fb291528f680.webp)

]

**2. 通过包管理工具查询软件包详细信息：**

以TLinux为例，执行`rpm -qi wget`命令，即可查阅该软件包所遵循的许可证类型。

![](https://static.motorao.cn/assets/pic/1b39fe61-9db0-80ce-a7f0-c342cb8a4a59.webp)

## **1.2 开源许可证的分类**

开源许可证主要分为两大类型，它们在代码使用自由度、商业兼容性和法律约束方面存在显著差异：

### **1.2.1 宽松型许可证（Permissive）**

宽松型许可证以对用户施加**最小限制**为核心特征，允许**自由使用、修改和分发代码**，同时确保对商业应用的友好性。用户只需在重新分发时保留原始版权声明和许可证文本副本，无需强制公开修改后的代码。

**核心特点**：允许闭源使用和商业集成，仅需保留原始版权声明。这类协议对二次开发限制最少，适合希望代码被广泛采用的项目。

**典型协议**：

* **MIT**：最简化的协议，仅要求保留版权声明，允许任意形式的代码使用

* **Apache 2.0**：在MIT基础上增加专利授权条款，明确禁止使用项目商标进行推广

* **BSD**：分2-Clause（仅保留声明）和3-Clause（额外禁止用作者名义宣传）两种版本

### 1.2.2 著佐权型许可证（Copyleft）

要求任何修改或添加原始软件的开发人员在分发包含copyleft许可代码的二进制文件时，通常都需要共享这些更改的源代码。核心机制在于**通过法律条款确保软件自由共享的延续性**。即通过所谓的"传染性"条款，保障代码开放性。又可细分为以下两类

* **强著佐权**：任何包含或修改原始代码的衍生作品**必须完全开源**，并继承相同许可证。如（GPL，APGL）

* **弱著佐权**：仅**修改部分需开源**，允许闭源代码通过动态链接等方式集成（如LGPL、MPL）

总而言之，两者的区别在于思维方式的差异。宽松型许可证接近于原教旨自由主义，主张彻底的自由，包括中间作者`将开源转为闭源`的自由。而著佐型许可证约束子代码与父代码保持相同许可证（即**许可证传染**），更倾向于保证开源产品的自始至终自由。

## 1.3 许可证不重视有什么后果

**1.商业赔偿 - GPL授权“传染”**

* * 济宁罗盒公司诉福建风灵侵权案（2024年）：**福建风灵创景科技有限公司使用了由济宁罗盒网络公司依据GPLv3协议所提供的开源软件VirtualApp。然而，风灵公司并未按照该协议的规定将修改后的代码开源。经过法院的审理判定，GPLv3协议具备法律效力，最终判决**风灵向罗盒赔偿50万元整**。

**法国Orange公司违反GPLv2案（2024年）**：Orange公司使用了以GPLv2授权的Lasso软件，但未按要求公开修改后的代码。法院判决**Orange公司支付65万欧元**，突显了企业在开源合规方面面临的严峻挑战。

**2. 服务下架 - TikTok Live Studio 违反 GPL 协议（2021年）**

* **争议点**：TikTok 使用 GPL 协议下的开源代码开发应用，但未按要求开源自身代码。

* **结果**：TikTok 下架相关应用，引发对 GPL“传染性”合规性的广泛讨论。

**3. 强制开源 - Redis 许可证变更风险（2024年）**

* Redis 从 BSD 协议改为 **RSALv2 + SSPLv1** 双许可，限制云厂商商业化使用。**RSALv2 条款**：明确禁止云厂商将 Redis 作为托管服务商业化提供给第三方，除非获得 Redis 商业授权。**SSPLv1 条款**：若云厂商基于 Redis 修改代码并提供服务，必须将修改后的代码及管理工具**全部开源**（包括部署、监控等基础设施代码）。

* **结果**：
    * 未获得授权的云厂商**无法提供 Redis 7.4 及更高版本**的托管服务，用户可能无法升级到新版本或购买相关服务
    * 社区分叉出 Valkey 项目，AWS、Google 等支持分叉，引发对“诱导转向”（bait-and-switch）商业策略的争议。

# 2. 开源许可证通过什么方式约束行为？

一般而言，开源许可证通过以下三个分类（及每个分类下的多个条约），来约定个体行为：

## 1. 权限（Permissions）

1. **商业用途（Commercial Use）**：明确产物和衍生品是否允许用于商业目的。

1. **分发（Distribution）**：规定产物是否可以被重新分发。

1. **修改（Modification）**：界定代码是否允许被修改。

1. **专利使用（Patent Use）**：明确授予贡献者使用专利的权利。

1. **私有使用（Private Use）**：规定是否可以在私有场合使用和修改代码。

### 2.2 条件（Conditions）

1. **披露来源（Disclose Source）**：规定在分发时是否必须提供源代码。

1. **许可证与版权声明（License and Copyright Notice）**：要求产物中必须包含原始许可证和版权声明。

1. **许可证与版权声明的来源（Source of License and Copyright Notice）**：规定许可证和版权声明的副本是否必须以源代码形式附带。

1. **网络分发使用（Network Distribution）**：确保所有互联网用户平等地享有接受源代码的权利。

1. **相同许可证（Same License）**：规定对产物进行分发时，修改后的代码必须采用相同的许可证。

1. **相同许可证 - 文件级别（Same License - File Level）**：规定对现有文件的修改在分发时必须采用相同的许可证。

1. **相同许可证 - 库级别（Same License - Library Level）**：对库级别的许可证做出约定。

1. **状态变更（State Change）**：要求对产物的更改必须进行记录（即Changelog）。

### 2.3 限制（Limitations）

1. **责任限制（Limitation of Liability）**：声明许可证包含责任限制条款。

1. **专利使用限制（Patent Use Limitation）**：明确声明未授予贡献者任何专利权利。

1. **商标使用限制（Trademark Use Limitation）**：明确声明不授予商标权。

1. **担保/保修（Warranty）**：明确声明不提供任何质量担保或保修。

# 3. 常见的开源许可证

开源届的许可证不下百种（以https://pypi.org/search/ 为例），下面以常见的几类进行介绍：

![](https://static.motorao.cn/assets/pic/1ad9fe61-9db0-80c7-84f4-ca9b29a1037f.webp)

## **BSD License**（Berkeley Software Distribution License）**:**

BSD 许可证的版本演化路径为4-Clause BSD ==> 3-Clause BSD ==> 2-Clause BSD => 0-Clause BSD（其中4-Clause即指4个条款）。

> 【原文】
这份许可证，在用户符合以下四条件的情形下，授予用户使用及再散播本软件包装源代码及二进位可执行形式的权利，无论此包装是否经改作皆然：
1. 版权声明条款：源代码的再分发必须保留上述版权声明、这些条件列表以及以下免责声明。
2. 免责声明条款：以二进制形式的再分发必须在文档和/或与分发一起提供的其他材料中复制上述版权声明、此条件列表以及以下免责声明。
3. 广告条款：所有提及本软件特性或使用的广告材料都必须显示以下确认：本产品包含由<版权所有者>开发的软件。 -- 在3-Clause BSD中移除。4. 非认可条款：无论是<版权所有者>的名称，还是其贡献者的名称，在没有特定的事先书面许可的情况下，都不得用于为源自本软件的产品背书或促销。** --  在2-Clause BSD中移除。**
本软件由版权所有者和贡献者“按原样”提供，并且任何明示或暗示的保证，包括但不限于适销性和特定目的适用性的暗示保证，均予以否认。在任何情况下，版权所有者或贡献者均不对任何直接、间接、偶然、特殊、模范或后果性损害（包括但不限于采购替代商品或服务；使用损失、数据或利润损失；或业务中断）负责，无论其是由何种原因引起的，也无论其责任理论是合同、严格责任还是侵权（包括疏忽或其他），即使已被告知存在此类损害的可能性。

其核心特点是**允许自由使用**、修改（修改代码无需公开）和**分发（允许闭源分发）**代码，**包括商业用途（无强制开源要求）。**

| **典型应用** | **license说明** | **腾讯软件源地址** |
| ---------- | ---------- | ---------- |
| freebsd | [https://www.freebsd.org/copyright/freebsd-license/](https://www.freebsd.org/copyright/freebsd-license/) | [https://mirrors.tencent.com/freebsd/](https://mirrors.tencent.com/freebsd/) |
| go | [https://github.com/golang/go?tab=BSD-3-Clause-1-ov-file](https://github.com/golang/go?tab=BSD-3-Clause-1-ov-file) | [https://mirrors.tencent.com/help/go.html](https://mirrors.tencent.com/help/go.html) |

## **Apache 2.0**

Apache 2.0 许可证（Apache License 2.0，原文：[https://www.apache.org/licenses/LICENSE-2.0.txt](https://www.apache.org/licenses/LICENSE-2.0.txt)）是由 Apache 软件基金会（ASF）发布的**宽松型开源协议**，广泛应用于企业级开源项目。其核心条款如下：

1. **自由使用与分发：允许用户自由使用、修改、分发代码，包括商业用途，且不强制衍生作品开源**。分发时需保留原始版权声明和许可证文件。

1. **专利授权：贡献者自动授予用户不可撤销的专利使用权**，但若用户发起专利诉讼，授权将终止。

1. *修改标注要求：**修改后的文件需明确标注改动内容，并在衍生作品中保留原作的版权、专利声明及 NOTICE 文件（如有）。

1. *免责声明：**软件按“原样”提供，不承担任何质量担保或法律责任。

与BSD License相比，Apache2.0**明确授予用户专利使用权**，**且若用户对贡献者发起专利诉讼，相关专利授权将自动终止**（这就阻止用户利用贡献者授予的专利权利反过来起诉贡献者）,更注重法律严谨性。同时，Apache 2.0 的专利授权是**双向保护**的：贡献者授予用户专利使用权，但用户若发起专利诉讼，则视为破坏合作信任，贡献者可收回授权。这种机制既鼓励企业参与开源（无需担心专利风险），又保护了贡献者的核心利益。

**举例而言：假设企业 A 使用 Apache 2.0 项目 X 开发商业产品，随后起诉项目 X 的贡献者侵犯其专利。根据 Apache 2.0 条款，企业 A 将立即失去对项目 X 中所有贡献者专利的授权，导致其产品可能因专利侵权而无法继续使用或分发89**。这种后果对企业形成威慑，促使各方遵守开源协作规则，也正是因此相对完整的保护性，促使Apache2.0逐步成为开源社区当前最受欢迎的许可证之一。

|  |  |  |
| ---------- | ---------- | ---------- |
| **典型应用** | **license说明** | **腾讯软件源地址** |
| **apache相关项目** | [https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0) | [https://mirrors.tencent.com/apache/](https://mirrors.tencent.com/apache/) |
| **kubernetes** | [https://github.com/kubernetes/kubernetes?tab=Apache-2.0-1-ov-file](https://github.com/kubernetes/kubernetes?tab=Apache-2.0-1-ov-file) | [https://mirrors.tencent.com/kubernetes_new/](https://mirrors.tencent.com/kubernetes_new/) |
| **androidSDK** | [https://source.android.com/license?hl=zh-cn](https://source.android.com/license?hl=zh-cn) | [https://mirrors.tencent.com/AndroidSDK/](https://mirrors.tencent.com/AndroidSDK/) |
| **gradle** | [https://docs.gradle.org/current/userguide/licenses.html](https://docs.gradle.org/current/userguide/licenses.html) | [https://mirrors.tencent.com/gradle/](https://mirrors.tencent.com/gradle/) |

## **MIT License**

MIT许可证（MIT License）是由麻省理工学院（MIT）制定的**宽松开源协议**，以最简单的条款、**最低限度的义务**赋予用户**高度宽松的授权条款和其他授权的兼容性**，同时保留原作者的基本权利。

以下是其核心条款：
1.自由使用：**MIT许可证允许用户无限制地使用、复制、修改、合并、发布、分发和销售软件，且无需支付费用。开发者可将MIT代码集成到闭源商业项目中，而无需公开衍生作品的源代码，也不强制沿用MIT license（license不传染）。 **
2.保留声明：使用或分发代码时，需保留原作者的版权声明和许可声明。
3.免责条款：软件按“原样”提供，不承担任何责任（AS IS），用户需自行承担风险。

Deepseek即采用的该许可证，很显然，选择MIT许可证正表达了deepseek期望**最大化代码传播，拥抱商业化**的雄心。也正是通过MIT协议开放模型权重和训练框架，DeepSeek打破闭源巨头的技术垄断，加速AI技术普惠。

| **典型应用** | **license说明** | **腾讯软件源地址** |
| ---------- | ---------- | ---------- |
| **Deepseek** | [https://github.com/deepseek-ai/DeepSeek-V3?tab=MIT-1-ov-file](https://github.com/deepseek-ai/DeepSeek-V3?tab=MIT-1-ov-file) | N/A |
| **Node.js** | [https://github.com/nodejs/node?tab=License-1-ov-file](https://github.com/nodejs/node?tab=License-1-ov-file) | [https://mirrors.tencent.com/nodejs-release/](https://mirrors.tencent.com/nodejs-release/) |
| **Jenkins** | [https://www.jenkins.io/license/](https://www.jenkins.io/license/) | [https://mirrors.tencent.com/jenkins/](https://mirrors.tencent.com/jenkins/) |
| **flutter** | [https://github.com/Dart-Code/Flutter/blob/master/LICENSE](https://github.com/Dart-Code/Flutter/blob/master/LICENSE) | [https://mirrors.tencent.com/flutter/](https://mirrors.tencent.com/flutter/) |

## **GPL(GNU GPL)**

**GNU通用公共许可证（GPL）** 是一种典型的Copyleft协议，强调始终的自由共享和修改，由理查德·斯托曼（Richard Stallman）于1989年创建**。核心原则：**

1. 允许免费使用、修改和分发软件，但需附带源代码及完整许可证文本。

1. **Copyleft（著佐权）**：任何基于GPL软件修改或衍生的代码**必须同样以GPL开源（传染性）**，确保自由传播的延续性。

GPL为典型的Copyleft license，旨在保护软件从始至终的**自由性，即允许修改但需要始终保持免费和开源**。

| **典型应用** | **license说明** | **腾讯软件源地址** |
| ---------- | ---------- | ---------- |
| **linux-kernel** | [https://github.com/torvalds/linux?tab=License-1-ov-file](https://github.com/torvalds/linux?tab=License-1-ov-file) | [https://mirrors.tencent.com/linux-kernel/](https://mirrors.tencent.com/linux-kernel/) |
| **GNU** | [https://www.gnu.org/licenses/licenses.html](https://www.gnu.org/licenses/licenses.html) | [https://mirrors.tencent.com/gnu/](https://mirrors.tencent.com/gnu/) |
| **MariaDB** | [https://github.com/MariaDB/server?tab=GPL-2.0-1-ov-file](https://github.com/MariaDB/server?tab=GPL-2.0-1-ov-file) | [https://mirrors.tencent.com/mariadb/](https://mirrors.tencent.com/mariadb/) |
| **R/CRAN** | [https://www.r-project.org/about.html](https://www.r-project.org/about.html) | [https://mirrors.tencent.com/CRAN/](https://mirrors.tencent.com/CRAN/) |
| **VirtualBox** | [https://www.virtualbox.org/wiki/Licensing_FAQ](https://www.virtualbox.org/wiki/Licensing_FAQ) | N/A |

## **LGPL（GNU Lesser General Public License，宽通用公共许可证）**

为了扩大开源组织库函数的影响力，使GNU库函数的广泛应用，LGPL允许商业软件在一定条件下使用GNU库函数，而不受开源的影响。

在以LGPL发布的库的基础上开发新的库的时候，新的库必须以LGPL发布，**但是如果仅仅是动态链接，那么则不受限制。**这就给予了商业软件“使用开源库函数”的权利。**核心原则：**

1.允许闭源软件**通过动态链接使用 LGPL 库**，无需开源自身代码。
2.若直接修改 LGPL 库代码并分发，需公开修改部分。
3.常用于兼容商业软件的开源组件（如 GNU C 库）

| **典型应用** | **license说明** | **腾讯软件源地址** |
| ---------- | ---------- | ---------- |
| qt | [https://github.com/qt/qt?tab=License-3-ov-file](https://github.com/qt/qt?tab=License-3-ov-file) | [https://mirrors.tencent.com/qt/](https://mirrors.tencent.com/qt/) |
| GTK | [https://github.com/GNOME/gtk?tab=License-1-ov-file](https://github.com/GNOME/gtk?tab=License-1-ov-file) | N/A |

## **AGPL（GNU Affero General Public License，Affero通用公共许可证）**

AGPL 是 GPL 的扩展版本，属于**强著佐权（Copyleft）**协议，主要针对网络服务（SaaS）场景。其核心规则是：

1. 若基于 AGPL 代码提供网络服务（如**云平台**），**需向用户公开修改后的源代码**。

1. 弥补了传统 GPL 的“ASP 漏洞”，将**网络交互视为分发行为**，**强制衍生代码开源**。

1. 适用于**希望防止云厂商无偿使用开源代码的项目**（如 MongoDB 早期版本）。

| **典型应用** | **license说明** | **腾讯软件源地址** |
| ---------- | ---------- | ---------- |
| **Grafana** | [https://grafana.com/licensing/](https://grafana.com/licensing/) | N/A |
| **Nextcloud** | [https://help.nextcloud.com/t/nextcloud-licensing/206830](https://help.nextcloud.com/t/nextcloud-licensing/206830) | N/A |
| **Elasticsearch** | [https://www.elastic.co/pricing/faq/licensing](https://www.elastic.co/pricing/faq/licensing) | N/A |

* ASP漏洞：GPL协议要求分发软件时必须开源衍生代码，但传统 GPL 仅将“分发”定义为**物理传输二进制或源代码**。云厂商通过 SaaS 模式提供在线服务时，用户并未直接获得软件副本，因此**不触发 GPL 的开源条款，**云厂商无需公开修改后的代码。

## SSPL（Server Side Public License）

SSPL是由 MongoDB 公司于 2018 年推出的许可证，**主要针对云服务场景设计**，要求任何将 SSPL 许可的软件作为服务（SaaS）提供的企业，必须公开其全部相关代码（包括管理工具、监控系统等配套服务代码）。核心规则：
**1.服务触发开源：**若将 SSPL 软件以云服务形式提供（如数据库即服务），需将所有支持该服务的代码（包括修改后的代码、管理平台等）以 SSPL 协议开源。
**2.传染性条款：**修改或分发 SSPL 软件时，衍生作品必须使用 SSPL 协议，且需满足上述服务开源要求。

最终，AWS 因 SSPL 限制分叉 Elasticsearch 推出 **OpenSearch**，MongoDB 则通过 SSPL 推动云厂商购买商业授权。

| **典型应用** | **license说明** | **腾讯软件源地址** |
| ---------- | ---------- | ---------- |
| **MongoDB** | [https://opensource.stackexchange.com/questions/8025/difference-between-mongodb-sspl-and-gnu-agpl](https://opensource.stackexchange.com/questions/8025/difference-between-mongodb-sspl-and-gnu-agpl) | N/A |
| **Elastichsearch&kibana** | [https://www.elastic.co/pricing/faq/licensing](https://www.elastic.co/pricing/faq/licensing) | N/A |

## ‼️重要：无许可证的情况

开源许可证种类繁多，不一而足，更多可以在gnu项目页面查询：[https://www.gnu.org/licenses/license-list.html](https://www.gnu.org/licenses/license-list.html)  。但如果源代码没有带有给予其用户四个基本自由的许可证，除非它明确并有效地说明是公有领域作品，那么它不是自由软件。

任何可以有版权的作品默认是受版权法保护的，这里的“作品”包括程序。因此**无许可证的程序默认是受版权法保护的**。对于没有许可证的代码，有可能仅仅是下载运行就已经侵犯了版权，需要更加谨慎的评估下载、编译或运行可能存在的潜在风险。

# 4. 如何正确评估开源许可证

需要说明的是，开源许可证是没有优劣之分的，apache/go/kubernets甚至deepseek确实是借助宽松型许可证达到了吸引开发者参与、推动技术传播与应用、降低行业门槛和成本的效果；但linux-kernel/Git/Gcc等也正通过copyleft - GPL成功的将其始终保持了开源项目的自由性，形成了庞大的开源社区。

## 4.1 我是终端用户（anaconda，grafana，virtualbox）

以anaconda为例：

根据[anaconda用户协议](https://legal.anaconda.com/policies/en/#terms-of-service) ，个人或学术用途（非商业用途）可自由使用所有组件，但无法获得企业级支持。

但作为商业公司员工，若下载后用于公司运营（如开发软件、测试系统），则符合《最高人民法院关于审理著作权民事纠纷案件适用法律若干问题的解释》第21条定义的“商业使用”约定。因此不再获得“自由使用”权利，已经产生商业侵权行为。

## 4.2 我是开发者，如何在引入开源代码过程中确保合规。

对于开发者而言，由于宽松型许可证“不传染”的特性及对“可转闭源”的容忍，我们一般认为隶属于Permissive类型即宽松型开源许可证（MIT/APACHE/BSD等）是无风险或风险可控的。但对于Copyleft许可证（例如GPL等），需要结合项目实际情况，根据衍生品**是否要闭源（未来是否可能闭源）**/**是否要兼容其他许可证**等情况判断。

如果遇到有不常见不熟悉的许可证类型，则需要加倍警觉，小心其中可能存在的法律风险。例如SSPL或一些公司制定的[商业许可证](https://legal.anaconda.com/policies/en?name=terms-of-service#terms-of-service)。

## 4.3 我要对外发布开源项目

总的来说，产品自身的评估维度有这些：

1. **项目目标与权限控制：即是否允许闭源修改**，是否需要**传染性条款**，是否包含**专利授权条款等。**

1. **法律合规：**优先选择OSI认证的开源许可证如 MIT、Apache、GPL等，避免 SSPL 等“伪开源”协议

1. **社区与商业化：**宽松型许可证更吸引开发者、通常允许商业化；copyleft型更适合构建强社区生态，但需衍生品开源，可能在商业变现上存在限制。

![](https://static.motorao.cn/assets/pic/1ad9fe61-9db0-80d4-8427-e1f6235e37c7.webp)

> 来源：https://kaiyuanshe.github.io/oss-book/Open-Source-License.html
