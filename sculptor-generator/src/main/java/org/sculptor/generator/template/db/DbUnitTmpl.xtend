/*
 * Copyright 2007 The Fornax Project Team, including the original
 * author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.sculptor.generator.template.db

import org.sculptor.generator.ext.DbHelper
import org.sculptor.generator.ext.GeneratorFactory
import org.sculptor.generator.ext.GeneratorFactoryImpl
import org.sculptor.generator.ext.Helper
import org.sculptor.generator.ext.Properties
import org.sculptor.generator.util.DbHelperBase
import org.sculptor.generator.util.OutputSlot
import sculptormetamodel.Application

class DbUnitTmpl {
	private static val GeneratorFactory GEN_FACTORY = GeneratorFactoryImpl::getInstance()


	extension DbHelperBase dbHelperBase = GEN_FACTORY.dbHelperBase
	extension DbHelper dbHelper = GEN_FACTORY.dbHelper
	extension Helper helper = GEN_FACTORY.helper
	extension Properties properties = GEN_FACTORY.properties

def String emptyDbunitTestData(Application it) {
	fileOutput("dbunit/EmptyDatabase.xml", OutputSlot::TO_GEN_RESOURCES_TEST, '''
		�dbunitTestDataContent(it) �
	'''
	)
}

def String singleDbunitTestData(Application it) {
	if (getDbUnitDataSetFile != null)
		fileOutput(getDbUnitDataSetFile(), OutputSlot::TO_RESOURCES_TEST, dbunitTestDataContent(it))
	else
		""
}

def String dbunitTestDataContent(Application it) {
	'''
	<?xml version='1.0' encoding='UTF-8'?>
	<dataset>
		�val domainObjects  = it.getDomainObjectsInCreateOrder(true).filter(d | !isInheritanceTypeSingleTable(getRootExtends(d.^extends)))� 
		�FOR domainObject  : domainObjects� 
		<�domainObject.getDatabaseName()� /> 
		�ENDFOR� 
		�FOR joinTableName  : domainObjects.map[d | d.getJoinTableNames()]� 
		<�joinTableName� /> 
		�ENDFOR� 
	</dataset>
	'''
}
}
