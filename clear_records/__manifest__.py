# -*- coding: utf-8 -*-
{
    'name': "Delete all records",

    'summary': """Server Action to delete all records""",

    'description': """
        [2492489]
        """,

    'author': 'Odoo Inc',
    'website': 'https://www.odoo.com/',

    'category': 'Custom Development',
    'version': '1.0',
    'license': 'OEEL-1',

    # any module necessary for this one to work correctly
    'depends': ['sale_management', 'account', 'crm', 'stock', 'account_accountant', 'purchase', 'point_of_sale'],

    # always loaded
    'data': [
        'data/actions.xml',
        'data/unreserve.xml'
    ],
    # only loaded in demonstration mode
    'demo': [],
    'application': False,
}
