# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

from odoo import models, fields, api


class AccountMove(models.Model):
    _inherit = 'account.move'

    def unlink(self):
        for move in self:
            move.line_ids.unlink()
        return super(AccountMove, self.with_context(force_delete=True)).unlink()


class AccountBankStatement(models.Model):
    _inherit = 'account.bank.statement'

    def unlink(self):
        return super(models.Model, self).unlink()


class PosSession(models.Model):
    _inherit = 'pos.session'

    def unlink(self):
        for session in self.filtered(lambda s: s.statement_ids):
            session.statement_ids.with_context(force_delete=True).unlink()
        return super(PosSession, self.with_context(force_delete=True)).unlink()

class PosConfig(models.Model):
    _inherit = 'pos.config'

    def unlink(self):
        return super(models.Model, self).unlink()
